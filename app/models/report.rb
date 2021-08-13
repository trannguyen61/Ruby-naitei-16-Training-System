class Report < TraineeOnly
  validates :date, :description, presence: true
end
