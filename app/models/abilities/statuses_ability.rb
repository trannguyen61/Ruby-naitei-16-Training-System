module Abilities
  class StatusesAbility < ModelsAbility
    def trainee user
      can :read, Status do |status|
        status.course.trainees.include? user
      end
      can :update, Status do |status|
        status.user == user && status.updateable?
      end
    end

    def supervisor user
      can :read, Status do |status|
        status.course.supervisors.include? user
      end
    end
  end
end
