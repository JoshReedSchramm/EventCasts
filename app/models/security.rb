class Security
  def self.is_authenticated?(twitter_name)
    !twitter_name.nil? and !twitter_name.blank?
  end

  def self.can_edit_group?(user, group)
    is_authenticated?(user.twitter_name) and User.can_edit_group?(group, user.twitter_name)
  end
end