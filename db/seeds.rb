10.times do |n|
  name = "hocsinh#{n + 1}"
  email = "hocsinh#{n + 1}@test.com"
  password = "123123"
  User.create!  name: name,
                email: email,
                password: password,
                password_confirmation: password,
                role: User.roles[:trainee]
end

10.times do |n|
  name = "giaovien#{n + 1}"
  email = "giaovien#{n + 1}@test.com"
  password = "123123"
  User.create!  name: name,
                email: email,
                password: password,
                password_confirmation: password,
                role: User.roles[:supervisor]
end
