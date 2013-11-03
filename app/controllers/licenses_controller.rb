class LicensesController < ApplicationController
  respond_to :html

  def show
    @license = License.friendly.find(params[:id])
    authorize! :read, @license

    respond_with @license do |f|
      f.html { redirect_to license_photographs_path(@license) }
    end
  end
end
