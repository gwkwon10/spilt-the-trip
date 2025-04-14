class SessionController < ApplicationController
  # new session
  def new
  end
  # create new session for user
  def create
    @user = User.find_by(email: params[:email])
    Rails.logger.debug "got into create"
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Logged In!"
    else
      flash.now[:alert] = "Invalid email or password"
      Rails.logger.debug "Entered Invalid"
      render :new
    end
  end
  # end the session
  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "Logged out!"
  end
end
