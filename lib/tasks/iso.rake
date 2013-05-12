namespace :iso do
  namespace :maintenance do
    task :repair_image_permissions => :environment do
      bucket = $s3_client.buckets.find(ENV['S3_BUCKET'])
      to_fix = []
      Photograph.find_each do |p|
        #if p.image_uid =~ /2013\//
          to_fix << p
        #end
      end

      to_fix.each do |p|
        begin
          obj = bucket.objects.find(p.image_uid)
          obj.copy(key: p.image_uid, bucket: bucket, acl: :private)  
          puts "Updated ACL for ##{p.id}: #{p.image_uid}"
        rescue S3::Error::NoSuchKey
          puts "No such key ##{p.id}: #{p.image_uid}"
        end
      end
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
      end
    end
  end
end
