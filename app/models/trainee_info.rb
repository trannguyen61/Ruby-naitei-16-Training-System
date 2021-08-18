class TraineeInfo < TraineeOnly
  POST_ATTRS = %i(university garaduate_year).freeze
  DATE_ATTRS = %i(start_training_time finish_training_time).freeze
  UPDATE_ATTRS = %i(id university garaduate_year
                    start_training_time finish_training_time).freeze

  validates :university, length: {maximum: Settings.string.length.max}
  validates :garaduate_year,
            numericality: {greater_than_or_equal_to: Time.zone.now.year},
            allow_nil: true
end
