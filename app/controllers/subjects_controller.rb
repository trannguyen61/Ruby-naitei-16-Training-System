class SubjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :supervisor_user, except: :show
  before_action :load_subject, except: %i(create new)
  before_action ->{correct_supervisor @subject}, only: %i(edit update destroy)

  def new; end

  def show
    @tasks = @subject.tasks.oldest_task.page(params[:page])
                     .per Settings.subject.paginate
    @task = Task.new
  end

  def create
    @subject = Subject.new create_subject_params
    if @subject.save
      flash[:success] = t ".success_create"
    else
      flash[:danger] = @subject.errors.full_messages.to_sentence
    end
    redirect_to course_path params[:subject][:course_id]
  end

  def edit; end

  def update
    if @subject.update update_subject_params
      flash[:success] = t ".success_updated"
      redirect_to @subject.course
    else
      flash[:danger] = t ".fail_update"
      render :edit
    end
  end

  def destroy
    if @subject.destroy
      flash[:success] = t ".success_destroy"
    else
      flash[:danger] = t ".fail_destroy"
    end
    redirect_to @subject.course
  end

  private
  def create_subject_params
    params.require(:subject).permit Subject::POST_ATTRS
  end

  def update_subject_params
    params.require(:subject).permit Subject::PATCH_ATTRS
  end

  def load_subject
    @subject = Subject.find_by id: params[:id]
    return if @subject

    flash[:danger] = t "subjects.error.invalid_subject"
    redirect_to courses_path
  end
end
