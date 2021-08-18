class UsersController < ApplicationController
  before_action :load_user, except: %i(new create)
  before_action :logged_in_user, only: %i(edit update)
  before_action :correct_user, only: %i(edit update)

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

  def edit
    return unless @user.role_trainee?

    @user.trainee_info = TraineeInfo.find_by id: params[:id]
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
end
