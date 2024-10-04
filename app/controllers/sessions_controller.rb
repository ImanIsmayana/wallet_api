class SessionsController < ApplicationController
  before_action :require_login, except: %I[create]

  def create
    user = User.find_by(email: params[:email])

    # without external gem i just can set like this on checking password haha
    if user && user.password == params[:password]
      # Store user ID in session
      session[:user_id] = user.id 
      render json: { message: 'Successfully logged in', user_id: user.id }, status: :ok
      return
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
      return
    end
  end

  def destroy
    session[:user_id] = nil # Clear session
    render json: { message: 'Successfully logged out' }, status: :ok
    return
  end
end