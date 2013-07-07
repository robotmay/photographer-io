require "machinist/active_record"

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
