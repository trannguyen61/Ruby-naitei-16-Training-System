class ReportsController < ApplicationController
  def new
    @report = current_user.reports.build
  end

  def create
    @report = Report.new create_report_params
    if @report.save
      flash[:success] = t ".success_reported"
      redirect_to root_url
    else
      flash[:error] = t ".fail_reported"
      render :new
    end
  end

  private

  def create_report_params
    params.require(:report).permit Report::CREATE_ATTRS
  end
end
