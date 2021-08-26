class Status < ApplicationRecord
  UPDATE_ATTRS = %i(status).freeze

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
  delegate :user, to: :enrollment

  scope :subject_type, ->{joins :subject}
  scope :ordered, ->{includes(:subject).order "subjects.start_time"}
  scope :subject_id, ->(id){joins(:task).where tasks: {subject_id: id}}
  scope :subjects_ordered, ->{subject_type.ordered}
  scope :tasks_subject_id, ->(id){includes(:task).subject_id id}

  def subject_finished_rate
    if finishable_type == "Task"
      errors.add :finishable_type, :not_permitted_type
    else
      task_statuses = enrollment.statuses.tasks_subject_id finishable_id
      total_tasks = task_statuses.length
      finished_tasks = task_statuses.select(&:finished?).length

      if total_tasks != 0
        ((Float(finished_tasks) / total_tasks) * 100).ceil
      else
        0
      end
    end
  end
end
