class TraineeOnly < ApplicationRecord
  self.abstract_class = true
  belongs_to :user

  validate :can_belong_to_trainee_only

  def can_belong_to_trainee_only
    return unless user

    errors.add(:user, :trainee_only) unless user.role_trainee?
  end
end
