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

    @photographs = @photographs.view_for(current_user).page(params[:page])
    respond_with @photographs
  end

  def explore
    @photographs = Photograph.view_for(current_user).order("created_at DESC").page(params[:page])
    respond_with @photographs do |f|
      f.html { render :index }
    end
  end

  def favourite

  end

  def search
    photo_ids = if params[:keyword].present?
      @keyword_results = Metadata.with_keyword(params[:keyword])
      @keyword_results.pluck(:photograph_id)
    elsif params[:q].present?
      @text_results = Metadata.fulltext_search(params[:q])
      @keyword_results = Metadata.with_keywords(params[:q].split(" "))
      (@text_results.map(&:photograph_id) + @keyword_results.pluck(:photograph_id)).uniq
    end

    unless photo_ids.nil? || photo_ids.empty?
      @photographs = Photograph.view_for(current_user).where(id: photo_ids).page(params[:page])
    end

    respond_with @photographs do |f|
      f.html { render :index }
    end
  end

  def show
    @photograph = Photograph.fetch(params[:id])
    authorize! :read, @photograph
    respond_with @photograph
  end
end
