class Status < TraineeOnly
  enum status: {start: 0, inprogress: 1, finished: 2, canceled: 3}

  belongs_to :finishable, polymorphic: true
end
