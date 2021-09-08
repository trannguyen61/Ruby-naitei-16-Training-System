class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :set_locale

  private
  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    check = I18n.available_locales.include?(locale)
    I18n.locale = check ? locale : I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    return if user_signed_in?

    store_location
    flash[:danger] = t "please_login"
    redirect_to new_user_session_path
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "not_found"
    redirect_to root_path
  end

  def supervisor_user
    redirect_to courses_path unless current_user.role_supervisor?
  end

  def correct_supervisor pass_object
    return if pass_object.supervisors.include? current_user

    flash[:danger] = t "subjects.error.no_permission"
    redirect_to courses_path
  end

  def load_course course_id
    @course = Course.find_by id: course_id
    return if @course

    flash[:danger] = t "courses.invalid_course"
    redirect_to courses_path
  end

  def success_respond message, path, now = false
    flash.clear
    if now
      flash.now[:success] = message
    else
      flash[:success] = message
    end
    respond_to do |format|
      format.html{redirect_to path}
      format.js
    end
  end

  def fail_respond message, path
    respond_to do |format|
      format.html do
        flash[:danger] = message
        redirect_to path
      end
      format.js{render js: "alert('#{message}')"}
    end
  end

  def fail_respond_render_js message, path, now = false
    flash.clear
    if now
      flash.now[:danger] = message
    else
      flash[:danger] = message
    end
    respond_to do |format|
      format.html{redirect_to path}
      format.js
    end
  end
end
