require "rails_helper"

RSpec.describe User, type: :model do
  let(:trainee){FactoryBot.create :trainee, email: "A@example.com"}
  let(:supervisor){FactoryBot.create :supervisor}
  let(:course){FactoryBot.create :course}
  let(:report){FactoryBot.create :report, user: trainee, course: course}

  describe "validations" do
    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:role)}
    it {should validate_presence_of(:email)}
    it {should validate_presence_of(:password)}
  end

  describe "downcase email" do
    it {expect(trainee.email).to eq("a@example.com")}
  end

  describe "digest token" do
    subject{User.digest "123456"}
    it{expect(subject.class).to eq(BCrypt::Password)}
  end

  describe "create trainee" do
    it{expect(TraineeInfo.where user_id: trainee.id).to exist}
  end

  describe "check user role" do
    let(:admin){FactoryBot.create :supervisor}
    before do
      admin.update! role: :admin
      admin.check_user_role
    end

    it do
      role_errors = [I18n.t("activerecord.errors.models.user.attributes.role.not_permitted_role")]
      expect(admin.errors.messages[:role]).to eq(role_errors)
    end
  end

  describe "create supervision" do
    before do
      supervisor.create_supervision course.id
    end

    subject{Supervision.where user_id: supervisor.id}
    it{expect(subject).to exist}
  end

  describe "return reports by own courses" do
    before do
        supervisor.create_supervision course.id
    end
    
    it{expect(supervisor.reports_by_own_courses).to eq([report])}
  end
end
