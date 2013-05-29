class FavouritesController < ApplicationController
  respond_to :html, :json
  before_filter :authenticate_user!

  def create
    @favourite = current_user.favourites.new(favourite_params)
    authorize! :create, @favourite
    if @favourite.save
      respond_with @favourite do |f|
        f.html { render partial: "photographs/interactions", layout: false, locals: { photograph: @favourite.photograph } }
      end
    else
      respond_with @favourite, status: :unprocessable_entity do |f|
        f.html { render partial: "photographs/interactions", layout: false, locals: { photograph: @favourite.photograph } }
      end
    end
  end

  def destroy
    @favourite = current_user.favourites.find(params[:id])
    authorize! :destroy, @favourite 
    if @favourite.destroy
      respond_with @favourite do |f|
        f.html { render partial: "photographs/interactions", layout: false, locals: { photograph: @favourite.photograph } }
      end
    else
      respond_with @favourite, status: :bad_request do |f|
        f.html { render partial: "photographs/interactions", layout: false, locals: { photograph: @favourite.photograph } }
      end
    end
  end

  private
  def favourite_params
    params.permit(:photograph_id)
  end
end
