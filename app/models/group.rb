class Group < ActiveRecord::Base
  has_and_belongs_to_many :users  
  validates_presence_of :name, :on => :create, :message => "can't be blank"
  #validates_format_of :name, :with => /!\s+/, :on => :create, :message => "cannot contain spaces"
  
  def add_user_by_twitter_name(twitter_name)
    user = User.find_by_twitter_name(twitter_name) 
    self.users << user
  end
    
  def Group.filter_hash(group_name)
    group_name.slice!(0) if group_name[0,1] == '#'    
    group_name
  end
  
  def Group.find_group_from_heirarchy(group_names, parent_id=0)
    group = self.find(:first, :conditions =>["name=? and parent_id=?", group_names[0], parent_id])
    if (group.nil? || group_names.length == 1)
      return group
    else
      group_names.shift
      Group.find_group_from_heirarchy(group_names, group.id)
    end
  end
end
