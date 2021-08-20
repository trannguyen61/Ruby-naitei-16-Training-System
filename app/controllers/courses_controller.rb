class CoursesController < ApplicationController
  before_action :logged_in_user
  before_action :supervisor_user, except: %i(index show)
  before_action ->{load_course params[:id]}, except: %i(index create new)
  before_action ->{correct_supervisor @course}, only: %i(edit update destroy)

  def index
    @courses = if current_user.role_admin?
                 Course.page(params[:page]).per Settings.page_size
               else
                 Course.send("by_#{current_user.role}_id", current_user.id)
                       .page(params[:page]).per Settings.page_size
               end
  end

  def show
    @subjects = @course.subjects.newest_subject.page(params[:page])
                       .per Settings.subject.paginate
    @trainees = @course.trainees
    @supervisors = @course.supervisors
    @subject = @course.subjects.new
    @enrollment = @course.enrollments.new
    @supervision = @course.supervisions.new
  end

  def new
    @course = Course.new
  end

  def edit; end

  def create
    @course = Course.new create_course_params
    if @course.save
      current_user.create_supervision @course.id
      flash[:info] = t ".create_success"
      redirect_to courses_path
    else
      flash.now[:danger] = t ".create_fail"
      render :new
    end
  end

  def update
    if @course.update update_course_params
      flash[:success] = t ".update_course_success"
      redirect_to course_path(@course)
    else
      flash.now[:danger] = t ".update_course_fail"
      render :edit
    end
  end

  def destroy; end

  private

  def create_course_params
    params.require(:course).permit Course::POST_ATTRS
  end

  def update_course_params
    params.require(:course).permit Course::PATCH_ATTRS
  end
end
