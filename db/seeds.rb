User.create!(name:  "admin",
             email: "testadmin511@gmail.com",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true)

51.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@test.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end
#サンプルデータにマイクロポストを追加
users = User.order(:created_at).take(6)
5.times do
  name = Faker::Lorem.sentence(5)
  price = Faker::Lorem.sentence(5)
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content, name: name, price: price) }
end