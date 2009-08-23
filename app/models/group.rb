class Group < ActiveRecord::Base
  has_and_belongs_to_many :users  
  has_many :group_data
  validates_presence_of :name, :on => :create, :message => "hashtag can't be blank"
  validates_uniqueness_of :name, :scope => "parent_id", :message => "hashtag is already registered" 
  
  validates_format_of :name, :with => /^[A-Za-z0-9_]+$/, :on => :create, :message => "hashtag can only contain letters and numbers"
  attr_accessor :sub_groups
  
  def add_user_by_twitter_name(twitter_name, create_if_needed = false)
    user = User.find_by_twitter_name(twitter_name)
    if (create_if_needed)
      if user.nil?
        user = User.new()
        user.twitter_name = twitter_name
        user.save!
      end
    end
    self.users << user
  end
  
  def get_full_path(current_path=[])
    current_path.push(self.name)
    if (self.parent_id == 0)
      return current_path.reverse.join("/")
    else
      parent.get_full_path(current_path)
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
  
  def parent
    Group.find(self.parent_id)
  end
  
  def participants
    Group.pull_recent_tweets(self.get_full_path, 200)    
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

  def populate_sub_group
    sub_groups = Group.find_all_by_parent_id(self.id)
    unless sub_groups == nil
      self.sub_groups = Array.new()
      sub_groups.each do |g|
        self.sub_groups.push(g)
      end
    end
  end
  
  def get_vips
    @user_profiles = []
    self.users.each do |u|
      twitter_profile = u.get_twitter_profile
      if !twitter_profile.nil?
        @user_profiles << twitter_profile
      else
        @user_profiles << create_mock_profile
      end
    end
    @user_profiles
  end
  
  def Group.pull_recent_tweets(tag,num = nil,since = nil)
    # assume the user passes the full tag

    html = ""
    logger.debug("Got #{tag}")
    @terms = tag.split('/')
    @search = ""
    @match = ""
    @terms.each do |t|
      @search << "+##{t}"
      @match << "##{t} "
    end
    #remove trailing space
    @match.chop!

    logger.debug("Searching for #{@search}")
    logger.debug("Matching on #{@match}")


    twitter = Net::HTTP.start('search.twitter.com')
    # Set the form data with options
    command = "/search.json?" + "q=" + URI.escape("#{@search}")
    command << "&" + "per_page=" + num.to_s if !num.nil?
    command << "&" + "since_id=" + since.to_s if !since.nil?
    command << "&refresh=true" if !num.nil? || !since.nil?

    logger.debug("Request URI: " + command)

    req = Net::HTTP::Get.new(command)

    res = twitter.request(req)

    # Raise an exception unless Twitter
    # returned an OK result
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
      logger.debug("Got: "+j["text"])
      if j["text"] =~ /#{regex_match}/
        json_result.push(j)
      end
      logger.debug(regex_match)      
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
  
  def create_mock_profile
    ""
  end
  
  
end
