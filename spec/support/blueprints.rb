require "machinist/active_record"

Collection.blueprint do
  user
  name { Faker::Lorem.word }
end

Favourite.blueprint do
  user
  photograph
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
end

Recommendation.blueprint do
  photograph
  user
end

User.blueprint do
  name { Faker::Name.name }
  username { "threepwood_#{sn}" }
  email { Faker::Internet.email }
  password { "password" }
  password_confirmation { "password" }
end
