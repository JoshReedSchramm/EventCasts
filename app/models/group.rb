class Group < ActiveRecord::Base
  has_and_belongs_to_many :users  
  validates_presence_of :name, :on => :create, :message => "can't be blank"
  
  def add_user_by_twitter_name(twitter_name)
    user = User.find_by_twitter_name(twitter_name) 
    self.users << user
  end
    
  def Group.filter_hash(group_name)
    group_name.slice!(0) if group_name[0,1] == '#'    
    group_name
  end
end
