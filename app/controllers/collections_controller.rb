class CollectionsController < ApplicationController
  respond_to :html

  before_filter :set_parents
  def set_parents
    if params[:user_id].present?
      @user = User.fetch(params[:user_id])
    end

    if params[:category_id].present?
      @category = Category.fetch_by_slug(params[:category_id])
    end
  end

  def index
    if @user.present?
      @collections = @user.collections.public
      set_title(@user.name)
    elsif @category.present?
      @collections = @category.collections.public
      set_title(@category.name)
    else
      @collections = Collection.public
    end

    @collections = @collections.view_for(current_user).uniq.order("created_at DESC").page(params[:page])
    respond_with @collections
  end

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
