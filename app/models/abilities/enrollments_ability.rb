module Abilities
  class EnrollmentsAbility < CoursesMaterialAbility
    def initialize user
      super user, Enrollment
    end
  end
end
