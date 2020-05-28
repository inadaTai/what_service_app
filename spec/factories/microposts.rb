FactoryBot.define do
  factory :micropost do
    association :contributer, factory: :user
    price { "月額500円" }
    name { "動画サービス" }
    content { "良い動画が多い" }
    picture { File.open("#{Rails.root}/db/images_seeds/1.png") }
    created_at { 10.minutes.ago }
    id { "1" }
  end
end
