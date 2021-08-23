class Supervision < ApplicationRecord
  belongs_to :course
  belongs_to :user

  delegate :name, :email, prefix: true, to: :user

  validate :supervisor_only

  def supervisor_only
    return unless user

    errors.add(:user, :supervisor_only) unless user.role_supervisor?
  end
end
