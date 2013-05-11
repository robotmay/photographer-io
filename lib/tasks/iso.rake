namespace :iso do
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
