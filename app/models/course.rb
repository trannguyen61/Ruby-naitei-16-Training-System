class Course < ApplicationRecord
  has_many :subjects, dependent: :destroy
  has_many :tasks, through: :subjects
  has_many :enrollments, dependent: :destroy
  has_many :supervisions, dependent: :destroy
  has_many :trainees, through: :enrollments, source: :users
  has_many :supervisors, through: :supervisions, source: :users

  validates :name, presence: true,
    length: {maximum: Settings.string.length.max}, uniqueness: true
  validates :description, :start_time, presence: true
end
