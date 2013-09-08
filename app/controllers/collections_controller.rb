class CollectionsController < ApplicationController
  respond_to :html
  before_filter :hide_filters!, only: [:show]

  before_filter :set_parents
  def set_parents
    if params[:user_id].present?
      @user = User.find_by_id_or_username(params[:user_id])

      if @user.nil?
        old_name = OldUsername.find_by(username: params[:user_id])
        if old_name.present?
          redirect_to user_collections_path(old_name.user.username) and return
        end
      end
    end

    if params[:category_id].present?
      @category = Category.find(params[:category_id])
    end
  end

  def index
    if @user.present?
      @collections = @user.collections.visible
      set_title(@user.name)
    elsif @category.present?
      @collections = @category.collections.visible
      set_title(@category.name)
    else
      @collections = Collection.visible
    end

    @collections = @collections.view_for(current_user).uniq.includes(:user).order("last_photo_added_at DESC").page(params[:page])
    respond_with @collections
  end

  def explore
    @collections = Collection.view_for(current_user).uniq.includes(:user).order("last_photo_added_at DESC").page(params[:page])

    set_title t("titles.explore")

    respond_with @collections do |f|
      f.html { render :index }
    end
  end

  def show
    @collection = Collection.find(params[:id])
    authorize! :read, @collection
    track_view_for_collection(@collection)
    @photographs = @collection.photographs.visible.page(params[:page])
    respond_with @collection
  end

  def authenticate
    #TODO
  end

  private
  def track_view_for_collection(collection)
    unless user_signed_in? && current_user == collection.user
      collection.views.increment
    end
  end
end
