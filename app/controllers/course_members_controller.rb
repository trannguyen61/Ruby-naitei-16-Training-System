class CourseMembersController < ApplicationController
  before_action :authenticate_user!
  before_action ->{load_course params[:course_id]}, only: :create
  before_action ->{correct_supervisor @course}, only: :create
  before_action :load_user_by_email, only: :create

  rescue_from ActiveRecord::RecordNotUnique, with: :record_not_unique_rescue

  def create; end

  def destroy; end

  private

  def load_user_by_email
    @user = User.find_by email: params[:email]
    return if @user

    fail_respond t("not_found"), @course
  end

  def record_not_unique_rescue
    fail_respond t("member_added"), @course
  end
end
