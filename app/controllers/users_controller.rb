class UsersController < ApplicationController
  before_action :load_user, except: %i(new create)
  before_action :authenticate_user!, only: %i(show edit update)
  before_action :correct_user, only: %i(edit update)
  before_action :see_other_users, only: %i(show)
  before_action :update_without_password, only: %i(update)

  def new
    @user = User.new
  end

  def create
    @user = User.new create_user_params
    if @user.save
      flash[:success] = t ".success_signup"
      redirect_to root_url
    else
      flash[:error] = t ".fail_signup"
      render :new
    end
  end

  def show
    @trainee = TraineeInfo.find_by user_id: params[:id]
    @user_fields = User::SHOW_ATTRS
    @translated_fields = User::TRANSLATED_VALUE_ATTRS
    @trainee_fields = TraineeInfo::SHOW_ATTRS
    @date_fields = *TraineeInfo::DATE_ATTRS, *User::DATE_ATTRS
  end

  def edit
    return unless @user.role_trainee?

    @user.trainee_info = TraineeInfo.find_by user_id: params[:id]
  end

  def update
    if @user.update update_user_params
      flash[:success] = t ".profile_updated"
      redirect_to edit_user_path(current_user)
    else
      flash[:danger] = t ".fail_updated"
      render :edit
    end
  end

  private

  def create_user_params
    params.require(:user).permit User::CREATE_ATTRS
  end

  def update_user_params
    params.require(:user)
          .permit(
            User::UPDATE_ATTRS,
            trainee_info_attributes: TraineeInfo::UPDATE_ATTRS
          )
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def see_other_users
    return if @user.role_trainee? ||
              current_user?(@user) ||
              current_user.role_supervisor? ||
              current_user.role_admin?

    flash[:danger] = t "no_permission"
    redirect_to root_url
  end

  def update_without_password
    return if params[:user][:password].present?

    params[:user].delete(:password)
    params[:user].delete(:password_confirmation)
  end
end
