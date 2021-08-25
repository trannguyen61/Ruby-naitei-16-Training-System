class CoursesController < ApplicationController
  before_action :logged_in_user
  before_action :supervisor_user, except: %i(index)
  before_action ->{load_course params[:id]}, except: %i(index create new)
  before_action ->{correct_supervisor @course}, only: %i(edit update destroy)

  def index
    @courses = send("load_#{current_user.role}_courses").page(params[:page])
                                                        .per Settings.page_size
  end

  def show
    @subjects = @course.subjects.newest_subject.page(params[:page])
                       .per Settings.subject.paginate
    @enrollments = @course.enrollments.includes(:user)
    @supervisions = @course.supervisions.includes(:user)
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

  def load_trainee_courses
    current_user.enrollments
  end

  def load_supervisor_courses
    Course.by_supervisor_id current_user.id
  end

  def load_admin_courses
    Course.all
  end
end
