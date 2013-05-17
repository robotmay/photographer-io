require 'fog'

$cdn = Fog::CDN.new({
  provider: "AWS",
  aws_access_key_id: ENV['S3_KEY'],
  aws_secret_access_key: ENV['S3_SECRET']
})

