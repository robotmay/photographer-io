module Account
  class CollectionsController < AccountController
    respond_to :html

    def show
      @collection = current_user.collections.fetch(params[:id])
      authorize! :manage, @collection
      respond_with @collection do |f|
        f.html { redirect_to account_collection_photographs_path(@collection) }
      end
    end

    def new
      @collection = current_user.collections.new
      authorize! :create, @collection
      respond_with @collection
    end

    def create
      @collection = current_user.collections.new(collection_params)
      authorize! :create, @collection
      if @collection.save
        flash[:notice] = t("account.collections.create.succeeded")
        respond_with @collection do |f|
          f.html { redirect_to account_collection_path(@collection) }
        end
      else
        flash.now[:alert] = t("account.collections.create.failed")
        respond_with @collection, status: :unprocessable_entity do |f|
          f.html { render :new }
        end
      end
    end

    def edit
      @collection = current_user.collections.fetch(params[:id])
      authorize! :update, @collection
      respond_with @collection 
    end

    def update
      @collection = current_user.collections.fetch(params[:id])
      authorize! :update, @collection
      if @collection.update_attributes(collection_params)
        flash[:notice] = t("account.collections.update.succeeded")
        respond_with @collection do |f|
          f.html { redirect_to account_collection_path(@collection) }
        end
      else
        flash.now[:alert] = t("account.collections.update.failed")
        respond_with @collection, status: :unprocessable_entity do |f|
          f.html { render :edit }
        end
      end
    end

    def destroy

    end

    private
    def collection_params
      params.require(:collection).permit(:name, :public)
    end
  end
end
