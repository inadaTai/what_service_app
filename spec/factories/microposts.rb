FactoryBot.define do
  factory :micropost do
    price { "MyString" }
    name { "MyString" }
    content { "MyText" }
    user { nil }
  end
end
