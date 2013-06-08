class UsersController < ApplicationController
  respond_to :html
  before_filter :hide_filters!, only: [:show]

  def show
    @user = case
    when params[:id].to_i > 0
      User.find(params[:id])
    else
      User.find_by(username: params[:id])
    end

    authorize! :read, @user
    @photographs = @user.photographs.view_for(current_user).order("created_at DESC").page(params[:page])
    respond_with @user
  end
end
