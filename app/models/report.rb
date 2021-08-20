class Report < TraineeOnly
  CREATE_ATTRS = %i(course_id user_id date
                    description today_task tmr_task).freeze

  belongs_to :course

  validates :date, :today_task, :tmr_task, presence: true
end
