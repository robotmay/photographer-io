class UsersController < ApplicationController
  respond_to :html

  def show
    @user = User.find(params[:id])
    authorize! :read, @user
    respond_with @user do |f|
      f.html { redirect_to user_photographs_path(@user) }
    end
  end
end
