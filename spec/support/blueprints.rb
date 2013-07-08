require "machinist/active_record"

Metadata.blueprint do
  photograph
  title { Faker::Lorem.sentence }
  description { Faker::Lorem.paragraph }
end

Photograph.blueprint do
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
