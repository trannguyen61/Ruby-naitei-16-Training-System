class Enrollment < TraineeOnly
  belongs_to :course
  has_many :statuses, dependent: :destroy

  delegate :name, :email, prefix: true, to: :user
  delegate :name, :description, :start_time, :end_time, to: :course

  after_create :create_statuses

  scope :by_user_id, ->(id){where(user_id: id).includes :course}

  def create_statuses
    course.subjects.each do |subject|
      subject.statuses.create! enrollment_id: id
    end

    course.tasks.each do |task|
      task.statuses.create! enrollment_id: id
    end
  end
end
