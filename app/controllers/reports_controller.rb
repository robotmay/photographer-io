class ReportsController < ApplicationController
  respond_to :html
  before_filter :set_parents
  before_filter :authenticate_user!
  
  def new
    @report = current_user.reports.new
    authorize! :create, @report
    respond_with @report
  end

  def create
    @report = current_user.reports.new(report_params)
    authorize! :create, @report

    @report.reportable = @parent
    
    if @report.save
      flash[:notice] = t("reports.create.succeeded")
      respond_with @report do |f|
        f.html { redirect_to @report.reportable }
      end
    else
      flash.now[:alert] = t("reports.create.failed")
      respond_with @report, status: :unprocessable_entity do |f|
        f.html { render :new }
      end
    end
  end

  private
  def set_parents
    @parent = case
    when params[:collection_id].present?
      Collection.find(params[:collection_id])
    when params[:photograph_id].present?
      Photograph.find(params[:photograph_id])
    end
  end

  def report_params
    params.require(:report).permit(:reason)
  end
end
