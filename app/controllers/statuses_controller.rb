class StatusesController < ApplicationController
  before_action :logged_in_user
  before_action :load_status

  def show
    if @status.finishable_type == "Subject"
      @task_statuses = @enrollment.statuses
                                  .tasks_subject_id @status.finishable_id
    else
      fail_respond t("data_not_found"), courses_path
    end
  end

  private
  def load_status
    @status = Status.find_by id: params[:id]
    if @status
      @enrollment = @status.enrollment
      @course = @enrollment.course
    else
      fail_respond t("data_not_found"), courses_path
    end
  end
end
