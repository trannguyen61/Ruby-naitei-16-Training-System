require "rails_helper"

RSpec.describe Report, type: :model do
  let(:trainee){FactoryBot.create :trainee}
  let(:course){FactoryBot.create :course}
  let!(:reports){FactoryBot.create_list :report, 3,
                 user: trainee, course: course, date: 1.day.ago}

  describe "associations" do
    it {should belong_to :course}
  end

  describe "validations" do
    it {should validate_presence_of(:date)}
    it {should validate_presence_of(:today_task)}
    it {should validate_presence_of(:tmr_task)}
  end

  describe ".by_user_id" do
    it {expect(Report.by_user_id(trainee.id).pluck(:id)).to eq(reports.pluck(:id))}
  end

  describe ".by_course_id" do
    it {expect(Report.by_course_id(course.id).pluck(:id)).to eq(reports.pluck(:id))}
  end

  describe ".by_date" do
    it {expect(Report.by_date(1.day.ago).pluck(:id)).to eq(reports.pluck(:id))}
  end

  describe ".order_desc_date" do
    let!(:another_report){FactoryBot.create :report,
                    date: Time.now, course: course, user: trainee}

    it {expect(Report.order_desc_date.pluck(:id)).to eq([another_report, *reports].pluck(:id))}
  end
end
