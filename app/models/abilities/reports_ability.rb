module Abilities
  class ReportsAbility < ModelsAbility
    def trainee user
      can :manage, Report, user: user
    end

    def supervisor user
      can :read, Report do |report|
        user.supervised_courses.include? report.course
      end
    end
  end
end
