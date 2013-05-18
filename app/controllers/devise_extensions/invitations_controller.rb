class DeviseExtensions::InvitationsController < Devise::InvitationsController
  protected
  def after_invite_path_for(resource)
    new_user_invitation_path
  end
end
