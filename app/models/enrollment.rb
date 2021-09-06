class Enrollment < TraineeOnly
  belongs_to :course
  has_many :statuses, dependent: :destroy

  delegate :name, :email, prefix: true, to: :user
  delegate :name, :description, :start_time,
           :estimated_end_time, :status, to: :course

  after_create :create_statuses

  scope :by_user_id, ->(id){where(user_id: id).includes :course}

  ransack_alias :name, :course_name
  ransack_alias :description, :course_description
  ransack_alias :start_time, :course_start_time
  ransack_alias :estimated_end_time, :course_estimated_end_time
  ransack_alias :finish_time, :course_finish_time
  ransack_alias :activated, :course_activated

  def create_statuses
    course.subjects.each do |subject|
      subject.statuses.create! enrollment_id: id
    end

    course.tasks.each do |task|
      task.statuses.create! enrollment_id: id
    end
  end
end
