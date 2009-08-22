class Group < ActiveRecord::Base
  has_and_belongs_to_many :users  
  has_many :group_data
  validates_presence_of :name, :on => :create, :message => "can't be blank"
  #validates_format_of :name, :with => /!\s+/, :on => :create, :message => "cannot contain spaces"
  attr_accessor :sub_groups
  
  def add_user_by_twitter_name(twitter_name)
    user = User.find_by_twitter_name(twitter_name) 
    self.users << user
  end
  
  def get_full_path(current_path=[])
    current_path.push(self.name)
    if (self.parent_id == 0)
      return current_path.reverse.join("/")
    else
      parent = Group.find(self.parent_id)
      parent.get_full_path(current_path)
    end
  end
  
  def title
    get_data_item('title')
  end

  def description
    get_data_item('description')
  end  
  
  def Group.search_by_name(query)    
    if !query.nil?          
      words = query.split(" ")      
      words.each_with_index do |word, index|
        words[index] = Group.filter_hash(word)        
      end
      return Group.find_group_from_heirarchy(words, 0, "like")
    end
  end
    
  def Group.filter_hash(group_name)
    group_name.slice!(0) if group_name[0,1] == '#'    
    group_name
  end
  
  def Group.find_group_from_heirarchy(group_names, parent_id=0, conditional="=")
    group = Group.find(:first, :conditions =>["name "+conditional+" ? and parent_id=?", group_names[0], parent_id])
    if (group.nil? || group_names.length == 1)
      return group
    else
      group_names.shift
      Group.find_group_from_heirarchy(group_names, group.id)
    end
  end
  
  private
  
  def get_data_item(name)    
    items = self.group_data.select do |data|
      data.group_data_type.name == name
    end
    if (!items.nil? && items.length > 0)
      return items[0].description
    else
      return ""
    end
  end
  
end
