class CategoriesController < ApplicationController
  respond_to :html

  def show
    @category = Category.find(params[:id])
    authorize! :read, @category

    path = if request.referer =~ /\/photographs/i
      category_photographs_path(@category.slug)
    else
      category_collections_path(@category.slug)
    end

    respond_with @category do |f|
      f.html { redirect_to path }
    end
  end
end
