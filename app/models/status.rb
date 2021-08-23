class Status < ApplicationRecord
  enum status: {start: 0, inprogress: 1, finished: 2, canceled: 3}

  belongs_to :finishable, polymorphic: true
  belongs_to :enrollment
  belongs_to :subject, ->{where(statuses: {finishable_type: "Subject"})},
             foreign_key: "finishable_id", optional: true
  belongs_to :task, ->{where(statuses: {finishable_type: "Task"})},
             foreign_key: "finishable_id", optional: true
  delegate :name, :description, to: :finishable
  delegate :name, :description, to: :task, prefix: true, allow_nil: true
  delegate :name, :description, to: :subject, prefix: true, allow_nil: true
  delegate :start_time, :finish_time, to: :subject

  scope :subject_type, ->{joins :subject}
  scope :ordered, ->{includes(:subject).order "subjects.start_time"}
  scope :subject_id, ->(id){joins(:task).where tasks: {subject_id: id}}
  scope :subjects_ordered, ->{subject_type.ordered}
  scope :tasks_subject_id, ->(id){includes(:task).subject_id id}
end
