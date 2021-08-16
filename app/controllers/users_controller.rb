class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t ".success_signup"
      redirect_to root_url
    else
      flash[:error] = t ".fail_signup"
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit User::CREATE_ATTRS
  end
end
