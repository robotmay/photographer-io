class CollectionsController < ApplicationController
  respond_to :html

  def explore
    @collections = Collection.view_for(current_user).uniq.order("updated_at DESC").page(params[:page])

    set_title(t("titles.explore"))

    respond_with @collections do |f|
      f.html { render :index }
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
