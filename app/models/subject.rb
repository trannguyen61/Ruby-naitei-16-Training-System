class Subject < ApplicationRecord
  belongs_to :course
  has_many :tasks, dependent: :destroy
  has_many :statuses, as: :finishable, dependent: :destroy

  validate :must_start_after_course_start_time
  validates :start_time, presence: true
  validates :length,
            numericality: {only_integer: true, greater_than_or_equal_to:
                          Settings.subject.length.min}

  def must_start_after_course_start_time
    return unless start_time && course

    check = start_time < course.start_time
    errors.add(:start_time, :after_course_start_time) if check
  end
end
