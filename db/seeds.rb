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