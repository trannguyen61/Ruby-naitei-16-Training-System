require "rails_helper"

$subjects_count = 2
$tasks_count = 2

RSpec.describe Status, type: :model do
  let(:user){FactoryBot.create :trainee}
  let(:course){FactoryBot.create :course_with_subjects_tasks,
               subjects_count: $subjects_count, tasks_count: $tasks_count}
  let(:enrollment){FactoryBot.create :enrollment, course: course, user: user}
  let(:statuses){enrollment.statuses}
  let(:subject_statuses){statuses[0...$subjects_count]}
  let(:task_statuses){statuses[$subjects_count..-1]}

  describe ".subject_type" do
    it {expect(Status.subject_type).to eq(subject_statuses)}
  end

  describe ".subjects_ordered" do
    it {expect(Status.subjects_ordered).to eq(subject_statuses.reverse)}
  end

  describe ".tasks_subject_id" do
    it {expect(Status.tasks_subject_id(course.subjects.first.id))
              .to eq(task_statuses[0...$tasks_count])}
  end

  describe "#finished_rate" do
    before do
      task_statuses.first.finished!
      course.subjects.last.tasks.destroy_all
    end

    context "finished task status" do
      it "should return 100" do
        expect(task_statuses.first.finished_rate)
        .to eq(Settings.complete_rate)
      end
    end

    context "not finished task status" do
      it "should return 0" do
        expect(task_statuses.last.finished_rate)
        .to eq(0)
      end
    end

    context "subject that has task status" do
      it "should return number finished tasks/total tasks" do
        expect(subject_statuses.first.finished_rate).to eq(50)
      end
    end

    context "subject that has no task status" do
      it "should return 0" do
        expect(subject_statuses.last.finished_rate).to eq(0)
      end
    end
  end
end
