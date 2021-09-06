class Report < TraineeOnly
  CREATE_ATTRS = %i(course_id user_id date
                    description today_task tmr_task).freeze
  USER_SEARCH_QUERY = %w(course today_task tmr_task
                         description content date).freeze
  ADMIN_SEARCH_QUERY = %w(course today_task tmr_task
                          description content date created_at).freeze

  belongs_to :course

  delegate :name, to: :course, prefix: true
  delegate :name, to: :user, prefix: true

  validates :date, :today_task, :tmr_task, presence: true

  scope :by_user_id, ->(id){where user_id: id}
  scope :by_course_id, ->(ids){where course_id: ids}
  scope :by_date, ->(date){where date: date}
  scope :order_desc_date, ->{order date: :desc, course_id: :asc}

  ransack_alias :content, :today_task_or_description_or_tmr_task

  ransacker :created_at, type: :date do
    Arel.sql("date(reports.created_at)")
  end

  class << self
    def ransackable_attributes auth_object = nil
      if auth_object == :admin
        ADMIN_SEARCH_QUERY
      else
        USER_SEARCH_QUERY
      end
    end
  end
end
