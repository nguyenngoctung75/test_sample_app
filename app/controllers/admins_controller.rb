class AdminsController < ApplicationController
  before_action :authenticate_admin!
  load_and_authorize_resource :user

  def index
    @admin = current_admin
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def edit_user
    @user = User.find(params[:id])
    
    render 'admins/edit_user'
  end

  def update_user
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to admins_path, notice: 'User updated successfully'
    else
      render 'admins/edit_user'
    end
  end
end
