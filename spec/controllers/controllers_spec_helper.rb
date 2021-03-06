require 'spec_helper'

def redefine_cancan_abilities
  @ability = Object.new
  @ability.extend(CanCan::Ability)
  @controller.stub(:current_ability).and_return(@ability)
  @ability.can :manage, :all
end