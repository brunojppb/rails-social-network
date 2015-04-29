module SessionsHelper


  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def remember(user)
    # From now on, we can access the remember_token
    # virtual attribute from the user because the remember
    # method generated a new remember token and saved the
    # hash digest of the token into the database
    user.remember
    # send securely the user id to the user browser
    cookies.permanent.signed[:user_id] = user.id
    # send the remember token to the user browser
    # for future authentication
    cookies.permanent[:remember_token] = user.remember_token
  end

  # delete the user data from persistent session
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def current_user?(user)
    user == current_user
  end

  def current_user
    # Check if the user is logged in using session
    # in the case that he has chosen to not be remembered
    if user_id = session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
      # otherwise, if the user selected to be remembered
      # we are going to look up in the cookies
    elsif user_id = cookies.signed[:user_id]
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        # if the user is valid
        # we can log in him(using sessions)
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

end
