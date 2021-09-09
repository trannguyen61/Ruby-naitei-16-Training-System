module Abilities
  class SupervisionsAbility < CoursesMaterialAbility
    def initialize user
      super user, Supervision
    end
  end
end
