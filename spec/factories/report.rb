FactoryBot.define do
  factory :report do
    association :user
    association :course

    description {Faker::Lorem.sentence word_count: 5}
    today_task {Faker::Lorem.sentence word_count: 5}
    tmr_task {Faker::Lorem.sentence word_count: 5}
    date {Time.current}
  end

  factory :invalid_report, parent: :report do
    today_task {nil}
  end
end
