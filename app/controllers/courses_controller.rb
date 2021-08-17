class CoursesController < ApplicationController
  before_action :logged_in_user
  before_action :supervisor_user, except: %i(index show)

  def index
    @courses = if current_user.role_admin?
                 Course.page(params[:page]).per Settings.page_size
               else
                 Course.send("by_#{current_user.role}_id", current_user.id)
                       .page(params[:page]).per Settings.page_size
               end
  end

  def show
    @course = Course.find_by id: params[:id]
    if @course
      @subjects = @course.subjects.page(params[:page])
                         .per Settings.subject.paginate
      @subject = @course.subjects.new
    else
      flash[:danger] = t "courses.invalid_course"
      redirect_to courses_path
    end
  end

  def new
    @course = Course.new
  end

  def edit; end

  def create
    @course = Course.new course_params
    if @course.save
      current_user.create_supervision @course.id
      flash[:info] = t ".create_success"
      redirect_to courses_path
    else
      flash.now[:danger] = t ".create_fail"
      render :new
    end
  end

  def update; end

  def destroy; end

  private

  def course_params
    params.require(:course).permit Course::POST_ATTRS
  end
end
