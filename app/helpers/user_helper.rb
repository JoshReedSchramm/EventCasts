module UserHelper
  def logged_in_user
    session[:user]
  end
end
