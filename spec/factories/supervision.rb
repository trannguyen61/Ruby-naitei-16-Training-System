FactoryBot.define do
  factory :supervision do
    association :user
    association :course
  end
end
