FactoryBot.define do
  factory :comment do
    association :user, factory: :other_user
    association :micropost
    body { "Testtext" }
  end
end
