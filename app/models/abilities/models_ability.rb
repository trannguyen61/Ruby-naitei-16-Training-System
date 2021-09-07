module Abilities
  class ModelsAbility
    include CanCan::Ability
    def initialize user
      return if user.blank?

      if user.role_trainee?
        trainee user
      elsif user.role_supervisor?
        supervisor user
      end
    end

    def trainee user; end

    def supervisor user; end
  end
end
