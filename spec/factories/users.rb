FactoryBot.define do
  factory :user do
    name { "test" }
    email { "test@gmail.com" }
    password { "foobar" }
    password_confirmation { "foobar" }
  end
end
