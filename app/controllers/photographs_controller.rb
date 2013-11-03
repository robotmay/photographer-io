class PhotographsController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!, only: [:favourites, :recommend, :following]
  before_filter :hide_filters!, only: [
    :recommended, :favourites, :following, :search, :seeking_feedback
  ]
  before_filter :enable_sharing_mode, only: :share

  before_filter :set_parents
  def set_parents
    if params[:collection_id].present?
      @collection = Collection.friendly.find(params[:collection_id])
      authorize! :read, @collection
    end

    if params[:user_id].present?
      @user = User.find_by_id_or_username(params[:user_id])

      if @user.nil?
        old_name = OldUsername.find_by(username: params[:user_id])
        if old_name.present?
          redirect_to user_photographs_path(old_name.user.username) and return
        end
      end
    end

    if params[:category_id].present?
      @category = Category.friendly.find(params[:category_id])
    end

    if params[:license_id].present?
      @license = License.friendly.find(params[:license_id])
    end
  end

  def index
    case
    when @collection.present?
      @photographs = @collection.photographs
      set_title(@collection.name)
      hide_filters!
    when @user.present?
      @photographs = @user.photographs
      set_title(@user.name)
      hide_filters!
    when @category.present?
      @photographs = @category.photographs
      set_title(@category.name)
    when @license.present?
      @photographs = @license.photographs
      set_title(@license.name)
      hide_filters!
    else
      @photographs = Photograph.all
    end

    @photographs = @photographs.view_for(current_user).uniq.order("created_at DESC").page(params[:page])
    respond_with @photographs
  end

  def explore
    @photographs = Photograph.view_for(current_user).uniq.order("created_at DESC").page(params[:page])
    set_title t("titles.explore")

    respond_with @photographs do |f|
      f.html { render :index }
    end
  end

  def recommended
    @photographs = Photograph.recommended(page: params[:page])
    set_title t("titles.recommended")
    respond_with @photographs do |f|
      f.html { render :index }
    end
  end

  def favourites
    @photographs = current_user.favourite_photographs.order("favourites.created_at DESC").page(params[:page])
    set_title t("titles.favourites")
    respond_with @photographs do |f|
      f.html { render :index }
    end
  end

  def following
    @photographs = current_user.followee_photographs.view_for(current_user).order("created_at DESC").page(params[:page])
    set_title t("titles.following")
    respond_with @photographs do |f|
      f.html { render :index }
    end
  end

  def seeking_feedback
    @photographs = Photograph.joins(:comment_threads).view_for(current_user).order("comment_threads.created_at DESC").page(params[:page])
    set_title t("titles.seeking_feedback")
    respond_with @photographs do |f|
      f.html { render :index }
    end
  end

  def search
    if search_params[:q].blank? && search_params[:keyword].blank?
      redirect_to(photographs_path) and return
    end

    search = Photograph.search do
      if search_params[:q].present?
        fulltext search_params[:q]
      end

      if search_params[:keyword].present?
        with :keywords, search_params[:keyword]
      end

      with :public, true
      with :ghost, false

      unless user_signed_in? && current_user.show_nsfw_content
        with :safe_for_work, true
      end

      order_by :created_at, :desc
      paginate page: params[:page], per_page: Photograph.default_per_page
    end

    @photographs = search.results

    respond_with @photographs do |f|
      f.html { render :index }
    end
  end

  def random
    photographs = Photograph.view_for(current_user).order("RANDOM()")

    @photograph = if recently_viewed_user_ids.empty?
      photographs.first
    else
      photo = photographs.where.not(user_id: recently_viewed_user_ids.map(&:to_i)).first
      if photo.nil?
        recently_viewed_user_ids.clear
        photographs.first
      else
        photo
      end
    end

    authorize! :read, @photograph
    recently_viewed_user_ids << @photograph.user_id
    respond_with @photograph do |f|
      f.html { redirect_to photograph_path(@photograph) }
    end
  end

  def show
    @photograph = Photograph.find(params[:id])
    authorize! :read, @photograph

    track_view_for_photo(@photograph)
    
    set_title t("photographs.title", title: @photograph.metadata.title, by: @photograph.user.name)
    respond_with @photograph
  end

  def share
    @photograph = Photograph.find(params[:id])
    authorize! :read, @photograph

    track_view_for_photo(@photograph)

    if stale?(last_modified: @photograph.updated_at.utc, etag: [I18n.locale, @photograph], public: true)
      set_title t("photographs.title", title: @photograph.metadata.title, by: @photograph.user.name)
      respond_with @photograph do |f|
        f.html { render :show, layout: "share" }
      end
    end
  end

  def recommend
    @photograph = Photograph.find(params[:id])
    authorize! :recommend, @photograph
    @recommendation = current_user.recommendations.find_or_create_by_photograph_id(@photograph.id)
    if @recommendation
      respond_with @recommendation, status: :created do |f|
        f.html { render partial: "photographs/interactions", layout: false, locals: { photograph: @photograph } }
        f.json
      end
    else
      respond_with @recommendation, status: :unprocessable_entity do |f|
        f.html { render partial: "photographs/interactions", layout: false, locals: { photograph: @photograph } }
        f.json { render json: @recommendation.errors }
      end
    end
  end

  private
  def search_params
    params.permit(:q, :keyword)
  end

  def track_view_for_photo(photograph)
    unless user_signed_in? && current_user == photograph.user
      photograph.views.increment do
        photograph.user.photograph_views.increment
        photograph.user.push_stats
      end
    end
  end
end
