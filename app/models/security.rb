class Security
  def self.is_authenticated?
    !session[:twitter_name].nil? and !session[:twitter_name].blank?
  end

  def self.current_user_twitter_name
    session[:twitter_name]
  end

  def self.can_edit_group?(group)
    is_authenticated? and User.can_edit_group?(group, current_user_twitter_name)
  end
end