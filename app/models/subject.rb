class Subject < ApplicationRecord
  POST_ATTRS = %i(course_id name description start_time length).freeze
  PATCH_ATTRS = %i(name description start_time length).freeze

  belongs_to :course
  has_many :tasks, dependent: :destroy
  has_many :statuses, as: :finishable, dependent: :destroy
  has_many :supervisors, through: :course

  after_create :create_statuses
  after_save :update_course_estimated_end_time
  after_destroy :update_course_estimated_end_time

  validates :name, presence: true,
            length: {maximum: Settings.subject.name.max_length}
  validates :length,
            numericality: {only_integer: true, greater_than_or_equal_to:
                          Settings.subject.length.min}
  validates :start_time, presence: true
  validate :must_start_after_course_start_time
  scope :newest_subject, ->{order(created_at: :desc)}

  def must_start_after_course_start_time
    return unless start_time && course

    check = start_time < course.start_time
    return unless check

    errors.add(:start_time,
               :after_course_start_time,
               message: I18n.t("subjects.error.must_start_after_course"))
  end

  def finish_time
    start_time + length.days
  end

  private
  def create_statuses
    course.enrollments.each do |enrollment|
      status = Status.new finishable: self
      enrollment.statuses << status
    end
  end

  def update_course_estimated_end_time
    course.update_estimated_end_time
  end
end
