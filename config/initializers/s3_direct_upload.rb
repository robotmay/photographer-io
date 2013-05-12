if ENV['S3_ENABLED']
  S3DirectUpload.config do |c|
    c.access_key_id = ENV['S3_KEY']
    c.secret_access_key = ENV['S3_SECRET']
    c.bucket = ENV['S3_BUCKET']
    c.region = "s3-eu-west-1"
  end

  # Used for debugging
  $s3_client = S3::Service.new(
    access_key_id: ENV['S3_KEY'],
    secret_access_key: ENV['S3_SECRET']
  )
end
