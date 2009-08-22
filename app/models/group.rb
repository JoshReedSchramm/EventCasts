class Group < ActiveRecord::Base
  has_and_belongs_to_many :users  
  
  def add_user_by_twitter_name(twitter_name)
    user = User.find_by_twitter_name(twitter_name) 
    self.users << user
  end
end
