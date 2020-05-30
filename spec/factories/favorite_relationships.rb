FactoryBot.define do
  factory :favorite_relationship do
    association :user, factory: :other_user
    association :micropost
  end
end
