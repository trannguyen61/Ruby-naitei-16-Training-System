class Course < ApplicationRecord
  POST_ATTRS = %i(name description start_time).freeze
  PATCH_ATTRS = %i(name description activated).freeze
  FINISH_ATTRS = %i(finish_time).freeze

  has_many :subjects, dependent: :destroy
  has_many :tasks, through: :subjects
  has_many :enrollments, dependent: :destroy
  has_many :supervisions, dependent: :destroy
  has_many :trainees, through: :enrollments, source: :user
  has_many :supervisors, through: :supervisions, source: :user

  validates :name, presence: true,
    length: {maximum: Settings.string.length.max},
    uniqueness: {case_sensitive: true}
  validates :description, :start_time, presence: true

  scope :by_supervisor_id,
        ->(id){joins(:supervisions).where(supervisions: {user_id: id})}
  scope :by_trainee_id,
        ->(id){joins(:enrollments).where(enrollments: {user_id: id})}

  def estimated_end_time
    subjects.reduce(start_time) do |max_end_time, subject|
      subject_start_time = subject.start_time || max_end_time
      subject_length = subject.length || 0

      subject_end_time = subject_start_time + subject_length.days
      max_end_time > subject_end_time ? max_end_time : subject_end_time
    end
  end

  def status
    if finish_time
      I18n.t "finished"
    elsif activated
      I18n.t "in_progress"
    else
      I18n.t "not_activated"
    end
  end
end
