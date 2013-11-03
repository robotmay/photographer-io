require "machinist/active_record"

Authorisation.blueprint do
  user
end

Collection.blueprint do
  user
  name { Faker::Lorem.word }
end

CollectionPhotograph.blueprint do

end

Comment.blueprint do
  user
  comment_thread
  body { Faker::Lorem.paragraph }
end

CommentThread.blueprint do
  user
  subject { Faker::Lorem.sentence }
end

Favourite.blueprint do
  user
  photograph
end

Following.blueprint do
  followee
  follower
end

License.blueprint do
  name { "Attribution" }
  code { "CC-BY" }
  slug { "cc-by" }
end

Metadata.blueprint do
  photograph
  title { Faker::Lorem.sentence }
  description { Faker::Lorem.paragraph }
end

Notification.blueprint do
  user
  subject { Faker::Lorem.sentence }
  body { Faker::Lorem.paragraph }
end

Photograph.blueprint do
  user
  image_uid { "wooster.jpg" }
  image_mime_type { "image/jpeg" }
  image_size { 5.megabytes }
end

Recommendation.blueprint do
  photograph
  user
end

Report.blueprint do
  user
  reason { Faker::Lorem.paragraph }
end

User.blueprint do
  name { Faker::Name.name }
  username { "threepwood_#{sn}" }
  email { Faker::Internet.email }
  password { "password" }
  password_confirmation { "password" }
  upload_quota { 100 }
  recommendation_quota { 10 }
end
