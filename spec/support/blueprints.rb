require "machinist/active_record"

User.blueprint do
  email { Faker::Internet.email }
  password { "password" }
  password_confirmation { "password" }
end
