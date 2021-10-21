# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.account_type == AccountType::ADMIN
      can :read, Question
      can :update, Question
      can :read, Review
      can :update, Review
      can :read, Feedback
      can :read, LinkClick
      can :read, Visit
      can :read, Registration
    elsif user.account_type == AccountType::PREMIUM || user.account_type == AccountType::STUDENT
      can :read, Question, visible: true
      can :create, Question
      can :read, Review, hidden: false
      can :create, Review
      can :create, Feedback
      can :create, LinkClick
      can :create, Visit
      can :create, Registration
      can :manage, Task
      can :manage, CalendarEvent
      can :manage, UserPreference
    elsif user.account_type == AccountType::FREE
      can :read, Question, visible: true
      can :create, Question
      can :read, Review, hidden: false
      can :create, Review
      can :create, Feedback
      can :create, LinkClick
      can :create, Visit
      can :create, Registration
      can :manage, Task
      can :manage, CalendarEvent
    else
      can :read, Question, visible: true
      can :create, Question
      can :read, Review, hidden: false
      can :create, Review
      can :create, Feedback
      can :create, LinkClick
      can :create, Visit
      can :create, Registration
    end

    #custom abilities
    can :manual_calendar, User if user.account_type == AccountType::PREMIUM || user.account_type == AccountType::STUDENT || user.account_type == AccountType::FREE
    can :auto_calendar, User if user.account_type == AccountType::STUDENT || user.account_type == AccountType::PREMIUM
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
