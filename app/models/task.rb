class Task < ApplicationRecord
  POST_ATTRS = %i(subject_id name description).freeze
  PATCH_ATTRS = %i(name description).freeze

  belongs_to :subject
  has_many :statuses, as: :finishable, dependent: :destroy
  has_many :supervisors, through: :subject

  validates :subject_id, presence: true
  validates :name, presence: true,
            length: {maximum: Settings.subject.name.max_length}
  scope :oldest_task, ->{order(created_at: :asc)}
end
