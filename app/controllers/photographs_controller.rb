class PhotographsController < ApplicationController
  respond_to :html

  def index
    @photographs = Photograph.scoped.page(params[:page])
    respond_with @photographs
  end

  def explore
    @photographs = Photograph.order("created_at DESC").page(params[:page])
    respond_with @photographs do |f|
      f.html { render :index }
    end
  end
end
