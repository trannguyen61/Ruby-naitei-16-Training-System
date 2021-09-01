require "rails_helper"

RSpec.describe Subject, type: :model do
  let(:course){FactoryBot.create :course_with_subjects_tasks,
    subjects_count: 2, tasks_count: 2}
  let(:subjects){course.subjects}
  let(:trainee){FactoryBot.create :trainee}
  let!(:enrollment){FactoryBot.create :enrollment, course: course, user: trainee}
  let(:statuses){enrollment.statuses}
  
  let(:invalid_subject){FactoryBot.create :subject, start_time: 1.year.ago}
  let(:valid_subject){FactoryBot.create :subject, course: course}

  
  describe "#create_statuses" do
    it "enrollment should have status" do
      expect {valid_subject}.to change {Status.count}
    end
  end

  describe "Associations" do
    it {is_expected.to belong_to(:course)}
    it {is_expected.to have_many(:tasks).dependent(:destroy)}
    it {is_expected.to have_many(:statuses).dependent(:destroy)}
    it {is_expected.to have_many(:supervisors).through(:course)}
  end

  describe "Validations" do
    it {is_expected.to validate_presence_of(:name)}
    it {is_expected.to validate_length_of(:name).is_at_most(Settings.subject.name.max_length)}
    it {is_expected.to validate_numericality_of(:length)
                   .only_integer
                   .is_greater_than_or_equal_to(Settings.subject.length.min)}
    it {is_expected.to validate_presence_of(:start_time)}
  end

  describe ".newest_subject" do
    it "should have the right order" do
      expect(subjects.order("created_at desc")).to eq(subjects.newest_subject)
    end
  end

  describe "#finish_time" do
    it "finish_time should be by the start_time with length" do
      expect(subjects.first.start_time + subjects.first.length*24*60*60).to eq(subjects.first.finish_time)
    end
  end

  describe "#must_start_after_course_start_time" do
    context "when start_time valid" do
      it "should raise error" do
        expect{invalid_subject}.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "when start_time after course's start_time" do
      it "should not raise error" do
        expect{valid_subject}.not_to raise_error
      end
    end
  end
end
