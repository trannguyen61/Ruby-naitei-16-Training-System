class TasksController < ApplicationController
  before_action :authenticate_user!, :supervisor_user
  before_action :load_task, except: %i(create new)
  before_action ->{correct_supervisor @task}, only: %i(edit update destroy)

  def new; end

  def create
    @task = Task.new create_task_params
    if @task.save
      flash[:success] = t "tasks.success_create"
    else
      flash[:danger] = @task.errors.full_messages.to_sentence
    end
    redirect_to subject_path params[:task][:subject_id]
  end

  def edit; end

  def update
    if @task.update update_task_params
      flash[:success] = t ".success_update"
      redirect_to @task.subject
    else
      flash[:danger] = t ".fail_update"
      render :edit
    end
  end

  def destroy
    if @task.destroy
      flash[:success] = t ".success_destroy"
    else
      flash[:danger] = t ".fail_destroy"
    end
    redirect_to @task.subject
  end

  private
  def create_task_params
    params.require(:task).permit Task::POST_ATTRS
  end

  def update_task_params
    params.require(:task).permit Task::PATCH_ATTRS
  end

  def load_task
    @task = Task.find_by id: params[:id]
    return if @task

    flash[:danger] = t "tasks.error.invalid_task"
    redirect_to courses_path
  end
end
