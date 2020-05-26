FactoryBot.define do
  factory :user do
    name { "test" }
    email { "test@gmail.com" }
    password { "foobar" }
    password_confirmation { "foobar" }
    admin { true }
  end

  factory :other_user, class: "User" do
    name { "yamamoto" }
    email { "yamamoto@gmail.com" }
    password { "foobar2" }
    password_confirmation { "foobar2" }
    id { "2" }
  end
end
