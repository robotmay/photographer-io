class FavouritesController < ApplicationController
  respond_to :html, :json
  before_filter :authenticate_user!

  def create
    @favourite = current_user.favourites.new(favourite_params)
    authorize! :create, @favourite
    if @favourite.save
      flash[:notice] = t("favourites.create.succeeded")
      respond_with @favourite do |f|
        f.html { redirect_to photograph_path(@favourite.photograph) }
      end
    else
      flash[:alert] = t("favourites.create.failed")
      respond_with @favourite, status: :unprocessable_entity do |f|
        f.html { redirect_to photograph_path(@favourite.photograph) }
      end
    end
  end

  def destroy
    @favourite = current_user.favourites.find(params[:id])
    authorize! :destroy, @favourite 
    if @favourite.destroy
      flash[:notice] = t("favourites.destroy.succeeded")
      respond_with @favourite do |f|
        f.html { redirect_to :back }
      end
    else
      flash[:alert] = t("favourites.destroy.failed")
      respond_with @favourite, status: :bad_request do |f|
        f.html { redirect_to :back }
      end
    end
  end

  private
  def favourite_params
    params.permit(:photograph_id)
  end
end
