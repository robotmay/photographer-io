class Account::PhotographsController < ApplicationController
  respond_to :html

  def index
    @photographs = current_user.photographs.order("created_at DESC").page(params[:page]).per(36)
    authorize! :manage, current_user.photographs.new
    respond_with @photographs
  end

  def new
    @photograph = current_user.photographs.new
    authorize! :create, @photograph
    respond_with @photograph
  end

  def create
    @photograph = current_user.photographs.new(photograph_params)
    authorize! :create, @photograph
    if @photograph.save!
      respond_with @photograph do |f|
        f.html { redirect_to edit_account_photograph_path(@photograph) }
        f.json { render json: @photograph.to_json }
      end
    else
      respond_with @photograph, status: :bad_request do |f|
        f.html { render :new }
        f.json { render json: @photograph.to_json }
      end
    end
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
