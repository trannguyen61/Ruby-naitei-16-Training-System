module Abilities
  class CoursesMaterialAbility < ModelsAbility
    def initialize user, model
      @model = model
      super user
    end

    def trainee user
      can :read, @model do |m|
        m.course.trainees.include? user
      end
    end

    def supervisor user
      can :manage, @model do |m|
        m.course.supervisors.include? user
      end
    end
  end
end
