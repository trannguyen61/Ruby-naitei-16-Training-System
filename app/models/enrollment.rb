class Enrollment < TraineeOnly
  belongs_to :course

  delegate :name, :email, prefix: true, to: :user
end
