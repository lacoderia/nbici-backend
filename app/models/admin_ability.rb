class AdminAbility
  include CanCan::Ability

  def initialize(admin_user)
    
    if admin_user.role? :super_admin
      can :manage, :all
      cannot :read, ScheduleForInstructor
    elsif admin_user.role? :instructor
      can :read, ActiveAdmin::Page, :name => "Dashboard"
      can :manage, ScheduleForInstructor
    elsif admin_user.role? :front_desk
      can :read, ActiveAdmin::Page, :name => "Dashboard"
      can :manage, Appointment
    end
 
  end
  
end
