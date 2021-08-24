class ReportsController < ApplicationController
  before_action :logged_in_user
  before_action :load_report, :correct_user, only: %i(edit update destroy)

  def index
    @paginate_reports = filtered_reports.page(params[:page])
                                        .per Settings.page_size
    @reports = @paginate_reports.to_a.group_by(&:date)
  end

  def new
    @report = current_user.reports.build
  end

  def create
    @report = Report.new create_report_params
    if @report.save
      flash[:success] = t ".success_reported"
      redirect_to reports_path
    else
      flash[:error] = t ".fail_reported"
      render :new
    end
  end

  def edit; end

  def update
    if @report.update create_report_params
      flash[:success] = t ".success_updated"
      redirect_to reports_path
    else
      flash[:error] = t ".fail_updated"
      render :edit
    end
  end

  def destroy
    if @report.destroy
      success_respond t(".success_destroy"), @report
    else
      fail_respond @report.errors.full_messages.to_sentence, @report
    end
  end

  private

  def create_report_params
    params.require(:report).permit Report::CREATE_ATTRS
  end

  def load_report
    @report = Report.find_by id: params[:id]
    return if @report

    flash[:danger] = t "report_not_found"
    redirect_to reports_path
  end

  def correct_user
    redirect_to reports_path unless current_user? @report.user
  end

  def filtered_reports
    filter_rp = if current_user.role_trainee?
                  current_user.reports.order_desc_date
                else
                  current_user.reports_by_own_courses
                end
    if params[:filter_date]
      filter_rp = filter_rp.by_date(params[:filter_date][:filter_date])
    end

    filter_rp
  end
end
