module Abilities
  class SubjectsAbility < CoursesMaterialAbility
    def initialize user
      super user, Subject
    end
  end
end
