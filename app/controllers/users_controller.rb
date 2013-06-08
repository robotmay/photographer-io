class UsersController < ApplicationController
  respond_to :html
  before_filter :hide_filters!, only: [:show]

  def show
    @user = User.find_by_id_or_username(params[:id])

    if @user.nil?
      old_name = OldUsername.find_by(username: params[:id])
      if old_name.present?
        redirect_to short_user_path(old_name.user.username) and return
      end
    end

    if @user.present?
      authorize! :read, @user
      @photographs = @user.photographs.view_for(current_user).order("created_at DESC").page(params[:page])
      respond_with @user
    else
      not_found
    end
  end
end
