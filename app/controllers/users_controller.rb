class UsersController < ApplicationController
  before_action :find_user, only: [:edit, :update, :show]

  def show

  end

  def edit

  end

  def update
    if @user.update_attributes(user_params)
      redirect_to action: 'show', id: @user
    else
      render action: 'edit'
    end
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :skype, :phone, :post, :avatar)
  end

end
