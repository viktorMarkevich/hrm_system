class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new # guest user
    # alias_action :create, :read, :update, :destroy, to: :crud

    can :manage, Sticker, owner_id: user.id
    # can :manage, User, id: user.id

    if user.post == 'Директор'
      can :read, [ Vacancy, Company, Candidate]
      can :manage, Event, user_id: user.id
    elsif user.post == 'HR Менеджер'
      can [:destroy, :update], [Event, Vacancy, Company, Candidate], user_id: user.id
      can [:read, :create], [Event, Vacancy, Company, Candidate]
    end || []

  end
end
