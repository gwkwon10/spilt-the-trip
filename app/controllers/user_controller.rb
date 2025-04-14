class UserController < ApplicationController
  def new
  end
  # add user to the database and go to trips
  def create
    @user = User.new(user_params)
    @user.user_id = (User.maximum(:user_id) || 0) + 1
    if @user.save
      session[:user_id] = @user.id
      redirect_to trips_path
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:displayName, :username, :password)
  end
end
