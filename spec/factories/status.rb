FactoryBot.define do
  factory :status do
    traits_for_enum(:status, {start: 0, inprogress: 1, finished: 2, canceled: 3})
  end
end
