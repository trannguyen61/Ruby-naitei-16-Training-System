# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize user
    merge Abilities::CoursesAbility.new(user)
    merge Abilities::EnrollmentsAbility.new(user)
    merge Abilities::SupervisionsAbility.new(user)
    merge Abilities::SubjectsAbility.new(user)
    merge Abilities::TasksAbility.new(user)
    merge Abilities::ReportsAbility.new(user)
    merge Abilities::StatusesAbility.new(user)
  end
end
