class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :read, Category
    can :read, Collection, public: true
    can :read, Photograph do |photograph|
      photograph.public?
    end
    can :read, User

    can :recommend, Photograph

    can :create, Favourite do |favourite|
      favourite.user == user && favourite.photograph.public? && favourite.photograph.user != user
    end
    can :destroy, Favourite, user_id: user.id

    can :create, Following do |following|
      following.follower == user && following.followee != user
    end
    can :destroy, Following, follower_id: user.id
    
    can :manage, Collection, user_id: user.id
    can :manage, Photograph, user_id: user.id
    can :manage, Metadata do |metadata|
      metadata.user == user
    end

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
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
