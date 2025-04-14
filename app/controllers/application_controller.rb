class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :current_user, :user_login?

  private

  def current_user
    @current_user ||= User.find_by(id: sesssion[:user_id])
  end

  def user_login?
    current_user.present?
  end

  def require_login
    unless user_login?
      flash[:alert] = "You must be logged in"
      redirect_to login_path
    end
  end
end
