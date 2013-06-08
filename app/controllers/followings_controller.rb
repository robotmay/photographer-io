class FollowingsController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!

  def create
    @user = User.find_by_id_or_username(following_params[:user_id])
    @following = current_user.follower_followings.find_or_initialize_by(followee_id: @user.id)
    authorize! :create, @following

    if @following.save
      flash[:notice] = t("followings.create.succeeded", name: @user.name)
      respond_with @following do |f|
        f.html { redirect_to :back }
      end
    else
      flash[:alert] = t("followings.create.failed")
      respond_with @following, status: :unprocessable_entity do |f|
        f.html { redirect_to :back }
      end
    end
  end

  def destroy
    @following = current_user.follower_followings.find(params[:id])
    authorize! :destroy, @following 
    if @following.destroy
      flash[:notice] = t("followings.destroy.succeeded")
      respond_with @following do |f|
        f.html { redirect_to :back }
      end
    else
      flash[:alert] = t("followings.destroy.failed")
      respond_with @following, status: :bad_request do |f|
        f.html { redirect_to :back }
      end
    end
  end

  private
  def following_params
    params.permit(:user_id)
  end
end
