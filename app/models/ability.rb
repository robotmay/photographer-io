class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    alias_action :create, :read, :update, :destroy, to: :crud

    can :read, Category
    can :read, Collection, visible: true
    can :read, Photograph do |photograph|
      photograph.visible?
    end
    can :read, User

    can :read, Collection do |collection|
      case
      when collection.shared && collection.requires_password? && collection.authenticated?
        true
      when collection.shared && !collection.requires_password?
        true
      else
        false
      end
    end

    can :recommend, Photograph

    can :manage, CommentThread, user_id: user.id
    can :read, CommentThread
    can :crud, Comment, user_id: user.id
    can :read, Comment, published: true 

    can :moderate, Comment do |comment|
      comment.comment_thread.user == user
    end

    can :read, Notification, user_id: user.id

    can :create, Favourite do |favourite|
      favourite.user == user && favourite.photograph.visible? && favourite.photograph.user != user
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

    can :manage, Authorisation, user_id: user.id
    
    can :create, Report do |report|
      report.user_id == user.id && user.moderator?
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
