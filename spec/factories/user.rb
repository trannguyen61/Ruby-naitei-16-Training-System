FactoryBot.define do
  factory :trainee, class: User do
    name {Faker::Name.name}
    email {Faker::Internet.safe_email}
    password {"password"}
    password_confirmation {"password"}
    role {User.roles[:trainee]}
  end

  factory :supervisor, class: User do
    name {Faker::Name.name}
    email {Faker::Internet.safe_email}
    password {"password"}
    password_confirmation {"password"}
    role {User.roles[:supervisor]}
  end

  factory :invalid_user, parent: :trainee do
    email {nil}
  end
end
