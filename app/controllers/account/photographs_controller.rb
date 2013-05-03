module Account
  class PhotographsController < AccountController
    respond_to :html

    before_filter :set_parents
    def set_parents
      if params[:collection_id].present?
        @collection = current_user.collections.fetch(params[:collection_id])
      end
    end

    def index
      if @collection.present?
        @photographs = @collection.photographs
      else
        @photographs = current_user.photographs
      end

      @photographs = @photographs.order("created_at DESC").page(params[:page])
      authorize! :manage, current_user.photographs.new
      respond_with @photographs
    end

    def public
      @photographs = current_user.photographs.public.order("created_at desc").page(params[:page])
      authorize! :manage, current_user.photographs.new
      respond_with @photographs do |f|
        f.html { render :index }
      end
    end

    def private
      @photographs = current_user.photographs.private.order("created_at desc").page(params[:page])
      authorize! :manage, current_user.photographs.new
      respond_with @photographs do |f|
        f.html { render :index }
      end
    end

    def unsorted
      not_photographs = current_user.photographs.in_collections.pluck(:id)
      @photographs = current_user.photographs.not_in(not_photographs).order("created_at DESC").page(params[:page])
      authorize! :manage, current_user.photographs.new
      respond_with @photographs do |f|
        f.html { render :index }
      end
    end

    def new
      @photograph = current_user.photographs.new
      authorize! :create, @photograph
      respond_with @photograph
    end

    def create
      @photograph = current_user.photographs.new(photograph_params)

      if @collection.present?
        @photograph.collections << @collection
      end

      authorize! :create, @photograph
      if @photograph.save
        respond_with @photograph do |f|
          f.html { redirect_to edit_account_photograph_path(@photograph) }
          f.json { render json: @photograph.to_json }
        end
      else
        respond_with @photograph, status: :bad_request do |f|
          f.html { render :new }
          f.json { render text: t("account.photographs.create.failed") }
        end
      end
    end

    def show
      @photograph = current_user.photographs.fetch(params[:id])
      authorize! :update, @photograph
      respond_with @photograph do |f|
        f.html { redirect_to edit_account_photograph_path(@photograph) }
      end
    end

    def edit
      @photograph = current_user.photographs.fetch(params[:id])
      authorize! :update, @photograph
      respond_with @photograph
    end

    def update
      @photograph = current_user.photographs.fetch(params[:id])
      authorize! :update, @photograph
      if @photograph.update_attributes(photograph_params)
        flash[:notice] = t("account.photographs.update.succeeded")
        respond_with @photograph do |f|
          f.html { redirect_to edit_account_photograph_path(@photograph) }
        end
      else
        flash.now[:alert] = t("account.photographs.update.failed")
        respond_with @photograph, status: :unprocessable_entity do |f|
          f.html { render :edit }
        end
      end
    end

    def destroy
      @photograph = current_user.photographs.fetch(params[:id])
      authorize! :destroy, @photograph
      if @photograph.destroy
        flash[:notice] = t("account.photographs.destroy.succeeded")
        respond_with @photograph do |f|
          f.html { redirect_to account_photographs_path }
        end
      else
        flash[:alert] = t("account.photographs.destroy.failed")
        respond_with @photograph, status: :bad_request do |f|
          f.html { redirect_to :back }
        end
      end
    end
    
    private
    def photograph_params
      params.require(:photograph).permit(
        :image, :safe_for_work, :license_id, collection_ids: [], metadata_attributes: [
          :id, :title, :keywords, :description
        ]
      )
    end
  end
end
