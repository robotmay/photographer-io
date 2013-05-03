class PhotographsController < ApplicationController
  respond_to :html

  def index
    @photographs = Photograph.public.page(params[:page])
    respond_with @photographs
  end

  def explore
    @photographs = Photograph.public.order("created_at DESC").page(params[:page])
    respond_with @photographs do |f|
      f.html { render :index }
    end
  end

  def favourite

  end

  def show
    @photograph = Photograph.fetch(params[:id])
    authorize! :read, @photograph
    respond_with @photograph
  end
end
