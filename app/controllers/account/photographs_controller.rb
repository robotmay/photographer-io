class Account::PhotographsController < ApplicationController
  respond_to :html

  def index
    @photographs = current_user.fetch_photographs.order("created_at DESC")
    authorize! :manage, current_user.photographs.new
    respond_with @photographs
  end

  def new

  end

  def create

  end

  def edit
    @photograph = current_user.photographs.fetch(params[:id])
    authorize! :update, @photograph
    respond_with @photograph
  end
  
  private
  def photograph_params
    params.require(:photograph).permit(:image)
  end
end
