class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      #hadle successful login
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      # if the user tried to access a protected page before
      # redirect him to this page
      redirect_back_or user
      # rails automatically converts redirect_to user to
      # named route user_url(user)
    else
      # create a error message and display
      flash.now[:danger] = "invalid email/password combination"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
