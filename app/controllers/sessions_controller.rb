class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])

    # If login successful
    #if user && user.authenticate(params[:password])
    if user = User.authenticate_with_credentials(params[:email], params[:password])
      session[:user_id] = user.id
      redirect_to '/'
    else
    # If login failed Redirect to login page
      redirect_to '/login'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/login'
  end
end