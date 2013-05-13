class CollectionsController < ApplicationController
  respond_to :html

  def explore
    @collections = Collection.view_for(current_user).uniq.order("updated_at DESC").page(params[:page])
    @photographs = @collections.map { |c| c.photographs.view_for(current_user).first }.compact

    respond_with @photographs do |f|
      f.html { render "photographs/index" }
    end
  end

  def show
    @collection = Collection.fetch(params[:id])
    authorize! :read, @collection
    respond_with @collection do |f|
      f.html { redirect_to collection_photographs_path(@collection) }
    end
  end
end
