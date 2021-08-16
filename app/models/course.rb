class Course < ApplicationRecord
  POST_ATTRS = %i(name description start_time).freeze

  has_many :subjects, dependent: :destroy
  has_many :tasks, through: :subjects
  has_many :enrollments, dependent: :destroy
  has_many :supervisions, dependent: :destroy
  has_many :trainees, through: :enrollments, source: :users
  has_many :supervisors, through: :supervisions, source: :users

  validates :name, presence: true,
    length: {maximum: Settings.string.length.max}, uniqueness: true
  validates :description, :start_time, presence: true

  scope :by_supervisor_id,
        ->(id){joins(:supervisions).where(supervisions: {user_id: id})}
  scope :by_trainee_id,
        ->(id){joins(:enrollments).where(enrollments: {user_id: id})}
end
