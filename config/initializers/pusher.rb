if ENV['PUSHER_URL'].nil? && ENV['PUSHER_APP_ID'].present?
  Pusher.app_id = ENV['PUSHER_APP_ID']
  Pusher.key = ENV['PUSHER_KEY']
  Pusher.secret = ENV['PUSHER_SECRET']
  Pusher.logger = Rails.logger
end
