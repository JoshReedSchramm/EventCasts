class Group < ActiveRecord::Base
  has_and_belongs_to_many :users  
  has_many :group_data
  belongs_to :parent,
             :class_name => "Group",
             :foreign_key => "parent_id"
  belongs_to :creator,
             :class_name => "User",
             :foreign_key => "creator_id"
  validates_presence_of :name, :on => :create, :message => "hashtag can't be blank"
  validates_uniqueness_of :name, :scope => "parent_id", :message => "hashtag is already registered" 
  
  validates_format_of :name, :with => /^[A-Za-z0-9_]+$/, :on => :create, :message => "hashtag can only contain letters and numbers"
  validate :user_can_edit_group?
  
  attr_accessor :sub_groups
  attr_accessor :editor
  
  def add_user_by_twitter_name?(twitter_name, create_if_needed = false)
    user = User.find_by_twitter_name(twitter_name)
    if (create_if_needed)
      if user.nil?
        user = User.new()
        user.twitter_name = twitter_name
        user.save!
      end
    end
    if !User.can_edit_group?(self, user.twitter_name)
      self.users << user
      return true
    else
      return false
    end
  end
  
  def get_full_path
    if (self.parent_id == 0)
      return self.name
    else
      return parent.get_full_path + "/" + self.name
    end
  end

  def owner
    if !self.users.nil? and self.users.length > 0
      self.users[0]
    else
      nil
    end 
  end
  
  def title
    get_data_item('title')
  end

  def description
    get_data_item('description')
  end  
  
  def has_parent?
    parent_id > 0
  end
  
  def participants
    tweets = Group.pull_recent_tweets(self.get_full_path, 200)    
    results = []
    tweets.each do |t|
      found = false
      results.each do |r| 
        if t["from_user"] == r["from_user"]
          found = true
        end
      end      
      results << t unless found
    end
    results
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

  def Group.find_by_description description
    Group.find(:all,
               :joins => :group_data,
               :conditions => ["group_data.group_data_type_id = ? and group_data.description like ?", 2, "%" + description + "%"])
  end

  def Group.find_by_title title
    Group.find(:all,
               :joins => :group_data,
               :conditions => ["group_data.group_data_type_id = ? and group_data.description like ?", 1, "%" + title + "%" ])
  end
  
  def Group.create_group(group_data, twitter_name)
    group = Group.new(group_data)
    user = User.find_by_twitter_name(twitter_name)    
    group.editor = user
    group.users << user
    group.name = Group.filter_hash(group.name)    
    group.creator = user
    group.save
    group
  end
  
  def populate_sub_group
    sub_groups = Group.find_all_by_parent_id(self.id)
    unless sub_groups == nil
      self.sub_groups = sub_groups
    end
  end
  
  def get_vips
    @user_profiles = []
    self.users.each do |u|      
      twitter_profile = u.get_twitter_profile
      if !twitter_profile.nil?
        @user_profiles << twitter_profile
      else
        @user_profiles << create_mock_profile(u.twitter_name)
      end
    end
    @user_profiles
  end
  
  def Group.pull_recent_tweets(tag,num = nil,since = nil)
    html = ""
    logger.debug("Got #{tag}")
    @terms = tag.split('/')
    @search = ""
    @match = ""
    @terms.each do |t|
      @search << "+##{t}"
      @match << "##{t} "
    end
    @match.chop!

    twitter = Net::HTTP.start('search.twitter.com')
    command = "/search.json?" + "q=" + URI.escape("#{@search}")
    command << "&" + "per_page=" + num.to_s if !num.nil?
    command << "&" + "since_id=" + since.to_s if !since.nil?
    if !num.nil?
      if !since.nil? && num <= 20
        command << "&refresh=true"
      end
    end

    req = Net::HTTP::Get.new(command)
    res = twitter.request(req)

    unless res.is_a? Net::HTTPOK
      html << res.body
    end

    result = JSON.parse(res.body)
    
    regex_to_build = @match.split(' ')
    regex_match = ""
    regex_to_build.each do |r|
      regex_match << r
      regex_match << "\\s*"
    end

    json_result = Array.new()
    result["results"].each do |j|
      if j["text"] =~ /#{regex_match}/
        json_result.push(j)
      end
    end

    json_result
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
  
  def create_mock_profile(twitter_name)
    vip = {}
    vip["profile_image_url"] = "http://twivatar.org/"+twitter_name+"/normal"
    vip["name"] = twitter_name
    vip["screen_name"] = ""
    vip
  end
  
  def user_can_edit_group?
    if !self.parent.nil?
      return Security.can_edit_group?(self.editor, self.parent)
    end
    return true
  end
end
