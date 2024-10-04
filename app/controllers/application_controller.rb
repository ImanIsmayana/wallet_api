class ApplicationController < ActionController::API
	include ActionController::Cookies

	private

  # methods for get current user login by session
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_login
    unless logged_in?
      render json: { error: 'You must be logged in to access this resource' }, status: :unauthorized
      return
    end
  end
end
