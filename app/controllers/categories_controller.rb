class CategoriesController < ApplicationController
  respond_to :html

  def show
    @category = Category.fetch_by_slug(params[:id])
    authorize! :read, @category
    respond_with @category do |f|
      f.html { redirect_to category_photographs_path(@category.slug) }
    end
  end
end
