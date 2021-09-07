module Abilities
  class CoursesAbility < ModelsAbility
    def trainee user
      can :read, Course do |course|
        course.trainees.include? user
      end
    end

    def supervisor user
      can :create, Course
      can :manage, Course do |course|
        course.supervisors.include? user
      end
    end
  end
end
