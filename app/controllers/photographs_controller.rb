class PhotographsController < ApplicationController
  respond_to :html

  before_filter :set_parents
  def set_parents
    if params[:collection_id].present?
      @collection = Collection.fetch(params[:collection_id])
      authorize! :read, @collection
    end
  end

  def index
    if @collection.present?
      @photographs = @collection.photographs
    else
      @photographs = Photograph.scoped
    end

    @photographs = @photographs.public.page(params[:page])
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

  def search

  end

  def show
    @photograph = Photograph.fetch(params[:id])
    authorize! :read, @photograph
    respond_with @photograph
  end
end
