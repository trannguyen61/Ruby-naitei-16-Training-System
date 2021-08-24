class Report < TraineeOnly
  CREATE_ATTRS = %i(course_id user_id date
                    description today_task tmr_task).freeze

  belongs_to :course

  delegate :name, to: :course, prefix: true
  delegate :name, to: :user, prefix: true

  validates :date, :today_task, :tmr_task, presence: true

  scope :by_user_id, ->(id){where user_id: id}
  scope :by_course_id, ->(ids){where course_id: ids}
  scope :by_date, ->(date){where date: date}
  scope :order_desc_date, ->{order date: :desc, course_id: :asc}
end
