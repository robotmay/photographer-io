class PhotographsController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!, only: [:favourites, :recommend, :following]
  before_filter :hide_filters!, only: [:recommended, :favourites, :following, :search]

  before_filter :set_parents
  def set_parents
    if params[:collection_id].present?
      @collection = Collection.fetch(params[:collection_id])
      authorize! :read, @collection
    end

    if params[:user_id].present?
      @user = User.fetch(params[:user_id])
    end

    if params[:category_id].present?
      @category = Category.fetch_by_slug(params[:category_id])
    end
  end

  def index
    if @collection.present?
      @photographs = @collection.photographs
      set_title(@collection.name)
      hide_filters!
    elsif @user.present?
      @photographs = @user.photographs
      set_title(@user.name)
      hide_filters!
    elsif @category.present?
      @photographs = @category.photographs
      set_title(@category.name)
    else
      @photographs = Photograph.scoped
    end

    @photographs = @photographs.view_for(current_user).uniq.order("created_at DESC").page(params[:page])
    respond_with @photographs
  end

  def explore
    @photographs = Photograph.view_for(current_user).uniq.order("created_at DESC").page(params[:page])
    set_title(t("titles.explore"))

    respond_with @photographs
  end

  def recommended
    sorted_photographs = Photograph.recommended(current_user)
    @photographs = Kaminari.paginate_array(sorted_photographs).page(params[:page]).per(Photograph.default_per_page)
    set_title(t("titles.recommended"))
    respond_with @photographs do |f|
      f.html { render :index }
    end
  end

  def favourites
    @photographs = current_user.favourite_photographs.order("favourites.created_at DESC").page(params[:page])
    set_title(t("titles.favourites"))
    respond_with @photographs do |f|
      f.html { render :index }
    end
  end

  def following
    @photographs = current_user.followee_photographs.view_for(current_user).order("created_at DESC").page(params[:page])
    set_title(t("titles.following"))
    respond_with @photographs do |f|
      f.html { render :index }
    end
  end

  def search
    @photographs = Photograph.search do
      fulltext search_params[:q]
      with :public, true
      order_by :created_at, :desc
      paginate page: params[:page], per_page: Photograph.default_per_page
    end

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
    @photograph = Photograph.fetch(params[:id])
    authorize! :read, @photograph

    unless user_signed_in? && current_user == @photograph.user
      @photograph.views.increment do
        @photograph.user.photograph_views.increment
        @photograph.user.push_stats
      end
    end
    
    set_title(@photograph.metadata.title)
    respond_with @photograph
  end

  def recommend
    @photograph = Photograph.fetch(params[:id])
    authorize! :recommend, @photograph
    @recommendation = current_user.recommendations.find_or_create_by_photograph_id(@photograph.id)
    if @recommendation
      flash[:notice] = t("recommendations.quota", amount: current_user.remaining_recommendations_for_today) 
      respond_with @recommendation, status: :created do |f|
        f.html { redirect_to :back }
        f.json
      end
    else
      flash[:alert] = @recommendation.errors
      respond_with @recommendation, status: :unprocessable_entity do |f|
        f.html { redirect_to :back }
        f.json { render json: @recommendation.errors }
      end
    end
  end

  private
  def search_params
    params.permit(:q)
  end
end
