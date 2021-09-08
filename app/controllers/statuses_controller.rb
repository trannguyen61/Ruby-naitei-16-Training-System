class StatusesController < ApplicationController
  before_action :authenticate_user!, :load_status, :load_task_status
  before_action :correct_user, :correct_start_time,
                :load_update_obj, only: %i(update)

  def show; end

  def update
    if @update_obj.update update_params
      handle_finished_all_subjects
      flash[:success] = t "success_updated"
      redirect_to @status
    else
      fail_respond t("data_not_found"), @status
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

  def correct_user
    redirect_to courses_path unless current_user? @status.user
  end

  def update_params
    params.permit Status::UPDATE_ATTRS
  end

  def load_task_status
    if @status.finishable_type == "Subject"
      @task_statuses = @enrollment.statuses
                                  .tasks_subject_id @status.finishable_id
      @finished_rate = @status.finished_rate
    else
      fail_respond t("data_not_found"), courses_path
    end
  end

  def handle_finished_all_subjects
    subject_statuses = @enrollment.statuses.subjects_ordered
    has_finished = subject_statuses
                   .reduce(true){|a, e| a && e.finished?}

    return unless has_finished

    finish_time = @update_obj.updated_at
    return if @enrollment.update finish_time: finish_time

    fail_respond t("data_not_found"), courses_path
  end

  def correct_start_time
    return unless @status.finishable.start_time > Time.now.utc

    fail_respond t("wrong_start_time"), courses_path
  end

  def load_update_obj
    @update_obj = Status.find_by id: params[:status_id]
    return if @update_obj

    fail_respond t("data_not_found"), @status
  end
end
