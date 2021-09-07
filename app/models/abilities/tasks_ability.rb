module Abilities
  class TasksAbility < CoursesMaterialAbility
    def initialize user
      super user, Task
    end
  end
end
