module SessionsHelper
  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    if cookies[:remember_token]
      @current_user ||= User.find_by(remember_token: cookies[:remember_token])
    end
  end

  def current_user?(user)
    current_user == user
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)  # Removes hash key so future signins don't forward here
  end

  def store_location
    # Session automatically expires on browser close
    session[:return_to] = request.url
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."  # Flash[:notice]
    end
  end
end