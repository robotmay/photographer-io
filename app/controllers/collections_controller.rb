class CollectionsController < ApplicationController
  respond_to :html

  def show
    @collection = Collection.fetch(params[:id])
    authorize! :read, @collection
    respond_with @collection do |f|
      f.html { redirect_to collection_photographs_path(@collection) }
    end
  end
end
