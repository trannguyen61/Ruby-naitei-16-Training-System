FactoryBot.define do
  factory :enrollment do
    association :user
    association :course
  end
end
