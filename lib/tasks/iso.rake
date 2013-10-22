namespace :iso do
  namespace :maintenance do
    task :create_stories => :environment do
      Notification.find_each(&:create_story)
    end

    task :repair_image_permissions => :environment do
      bucket = $s3_client.buckets.find(ENV['S3_BUCKET'])
      Photograph.find_each do |p|
        begin
          obj = bucket.objects.find(p.image_uid)
          obj.copy(key: p.image_uid, bucket: bucket, acl: :private)  
          puts "Updated ACL for ##{p.id}: #{p.image_uid}"
        rescue S3::Error::NoSuchKey
          puts "No such key ##{p.id}: #{p.image_uid}"
        end
      end
    end

    task :set_last_photo_created_at_on_collections => :environment do
      Collection.find_each do |collection|
        photo = collection.photographs.order("created_at DESC").first
        unless photo.nil?
          collection.update_column(:last_photo_created_at, photo.created_at)
        end
      end
    end

    task :repair_metadata => :environment do
      require 'csv'

      class Parser; include PgArrayParser; end

      file = Rails.root.join("lib/metadata_restore.csv")
      modified = 0

      CSV.foreach(file, col_sep: ";") do |row|
        begin
          changed = false
          m = Metadata.find(row[0])
          if row[2].present? && m.title.blank?
            m.title = row[2]
            changed = true
          end

          if row[3].present? && m.description.blank?
            m.description = row[3]
            changed = true
          end

          if row[4].present? && m.keywords.empty?
            m.keywords = Parser.new.parse_pg_array(row[4])
            changed = true
          end

          if changed
            puts "#{[m.id, m.title_was, m.keywords_was].inspect} => #{[m.id, m.title, m.keywords].inspect}"
            m.save!
            modified += 1
          end
        rescue Exception => ex
          puts "Error on #{row[0]}: #{ex.inspect}"
        end
      end

      puts "Changed: #{modified}"
    end
  end

  namespace :rankings do
    task :adjust_scores => :environment do
      Photograph.adjust_scores
    end
  end

  namespace :stats do
    task :reset_user_counters => :environment do
      User.find_each do |user|
        user.received_recommendations_count.reset
        user.received_recommendations_count.increment(
          user.received_recommendations.count
        )

        user.received_favourites_count.reset
        user.received_favourites_count.increment(
          user.received_favourites.count
        )

        user.followers_count.reset
        user.followers_count.increment(
          user.followers.count
        )
      end
    end

    task :reset_photo_counters => :environment do
      Photograph.find_each do |photo|
        Photograph.reset_counters(photo.id, :recommendations)
        Photograph.reset_counters(photo.id, :favourites)
      end
    end
  end

  namespace :locales do
    task :fetch => :environment do
      slug_map = {
        "enyml-5" => "%{locale}.yml",
        "categoriesenyml" => "categories.%{locale}.yml",
        "simple_formenyml" => "simple_form.%{locale}.yml",
        "deviseenyml" => "devise.%{locale}.yml",
        "devise_invitableenyml" => "devise_invitable.%{locale}.yml"
      }

      require 'open3'
      Open3.popen3("cd #{Rails.root} && tx pull -a") do |stdin, stdout, stderr, wait_thr|
        while line = stdout.gets
          match = line.match(/ -> (.*): (.*)/i)
          if match
            locale, original_file = match[1], match[2]
            p "Downloaded #{original_file} for #{locale}"

            match = original_file.match(/\.tx\/(.*)\.(.*)\/(.*)/i)
            slug = match[2]

            file_name = slug_map[slug] % { locale: locale }
            path = "config/locales/#{file_name}"

            p "Moving #{original_file} to #{path}"
            `cd #{Rails.root} && mv #{original_file} #{path}`
          end
        end
      end
    end
  end
end
