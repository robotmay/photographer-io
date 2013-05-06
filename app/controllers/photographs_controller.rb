class PhotographsController < ApplicationController
  respond_to :html

  before_filter :set_parents
  def set_parents
    if params[:collection_id].present?
      @collection = Collection.fetch(params[:collection_id])
      authorize! :read, @collection
    end

    if params[:user_id].present?
      @user = User.fetch(params[:user_id])
    end
  end

  def index
    if @collection.present?
      @photographs = @collection.photographs
      set_title(@collection.name)
    elsif @user.present?
      @photographs = @user.photographs
      set_title(@user.name)
    else
      @photographs = Photograph.scoped
    end

    @photographs = @photographs.view_for(current_user).page(params[:page])
    respond_with @photographs
  end

  def explore
    @photographs = Photograph.view_for(current_user).order("created_at DESC").page(params[:page])
    set_title(t("explore"))

    respond_with @photographs do |f|
      f.html { render :index }
    end
  end

  def recommended
    sorted_photographs = Photograph.recommended(current_user)
    @photographs = Kaminari.paginate_array(sorted_photographs).page(params[:page]).per(Photograph.default_per_page)
    respond_with @photographs do |f|
      f.html { render :index }
    end
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

    @photograph.views.increment do
      @photograph.user.photograph_views.increment
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
end
