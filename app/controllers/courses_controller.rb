class CoursesController < ApplicationController
  before_action :logged_in_user
  before_action :supervisor_user, except: %i(index)
  before_action ->{load_course params[:id]}, except: %i(index create new)
  before_action ->{correct_supervisor @course},
                only: %i(edit update destroy finish)
  before_action :load_course_enrollments, only: %i(show finish)

  def index
    @courses = send("load_#{current_user.role}_courses").page(params[:page])
                                                        .per Settings.page_size
  end

  def show
    @subjects = @course.subjects.newest_subject.page(params[:page])
                       .per Settings.subject.paginate
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

  def finish
    if @course.activated == false
      flash[:danger] = t ".not_activated"
    else
      update_finish_time
    end
    redirect_to course_path(@course)
  end

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

  def load_course_enrollments
    @enrollments = @course.enrollments.includes(:user)
  end

  def finish_course_params
    params.require(:course).permit Course::FINISH_ATTRS
  end

  def enrollment_not_finished_number
    @enrollments.select{|enrollment| enrollment.finish_time.blank?}.size
  end

  def update_finish_time
    if @enrollments.blank?
      flash[:warning] = t ".no_trainee"
    elsif enrollment_not_finished_number != 0
      flash[:danger] = t(".can_not_finish") +
                       " (#{enrollment_not_finished_number}) " +
                       t(".trainee_not_finish")
    elsif @course.update finish_course_params
      flash[:success] = t ".course_finished"
    else
      flash[:danger] = t".error_occurred"
    end
  end
end
