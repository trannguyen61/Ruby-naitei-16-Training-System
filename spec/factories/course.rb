FactoryBot.define do
  factory :task do
    association :subject
    name {Faker::Educator.course_name}
    description {Faker::Lorem.sentence word_count: 5}
  end

  factory :subject do
    association :course
    name {Faker::Educator.course_name}
    description {Faker::Lorem.sentence word_count: 5}
    start_time {Time.current}
    length {2}
    factory :subject_with_tasks do
      transient do
        tasks_count {2}
      end

      after(:create) do |subject, evaluator|
        create_list :task, evaluator.tasks_count, subject: subject
        subject.reload
      end
    end
  end

  factory :invalid_subject, parent: :subject do
    start_time {1.year.ago}
  end

  factory :invalid_task, parent: :task do
    name{"A" * (Settings.subject.name.max_length + 1)}
  end

  factory :course do
    name {Faker::Educator.course_name}
    description {Faker::Lorem.sentence word_count: 5}
    start_time {Time.current}
    factory :course_with_subjects_tasks do
      transient do
        subjects_count {2}
        tasks_count {2}
      end

      after(:create) do |course, evaluator|
        evaluator.subjects_count.times do |i|
          create :subject_with_tasks, course: course,
                 tasks_count: evaluator.tasks_count,
                 start_time: (evaluator.subjects_count - i - 1).days.from_now
        end
        course.reload
      end
    end
  end
end
