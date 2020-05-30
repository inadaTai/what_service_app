FactoryBot.define do
  factory :user, aliases: [:contributer] do
    name { "test" }
    email { "test@gmail.com" }
    password { "foobar" }
    password_confirmation { "foobar" }
    id { "1" }
    admin { true }
  end

  factory :other_user, class: "User" do
    name { "yamamoto" }
    email { "yamamoto@gmail.com" }
    password { "foobar2" }
    password_confirmation { "foobar2" }
    id { "2" }
  end

  factory :test_user, class: "User" do
    name { "test_user" }
    email { "test@example.com" }
    password { "foobar" }
    password_confirmation { "foobar" }
    id { "3" }
    sample { true }
  end

  factory :face_user, class: "User" do
    name { "face_user" }
    email { "face@example.com" }
    password { "foobar" }
    password_confirmation { "foobar" }
    id { "3" }
    uid { "1" }
  end
end
