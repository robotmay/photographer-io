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
end
