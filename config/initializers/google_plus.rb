require Rails.root.join("lib/google_plus")
$google_plus = GooglePlus.new({
  client_id: ENV['GOOGLE_CLIENT_ID'],
  secret: ENV['GOOGLE_SECRET'],
  api_key: ENV['GOOGLE_API_KEY']
})
