class DeviseExtensions::InvitationsController < Devise::InvitationsController
  before_filter :configure_permitted_parameters

  protected
  def after_invite_path_for(resource)
    new_user_invitation_path
  end

  def after_accept_path_for(resource)
    edit_user_registration_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:accept_invitation) { |u| u.permit(:name, :email, :password, :password_confirmation, :invitation_token) }
  end
end
