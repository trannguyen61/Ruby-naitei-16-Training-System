class Task < ApplicationRecord
  belongs_to :subject
  has_many :statuses, as: :finishable, dependent: :destroy
end
