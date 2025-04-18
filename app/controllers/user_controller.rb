class UserController < ApplicationController
  def new
    @user = User.new
  end
  # add user to the database and go to trips
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end
  private

  def user_params
    params.require(:user).permit(:displayName, :username, :email, :password, :password_confirmation)
  end
end
