class Event < ActiveRecord::Base
  has_and_belongs_to_many :users  
  has_many :event_data
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"

  validates_presence_of :name, :on => :create, :message => "hashtag can't be blank"
  validates_format_of :name, :with => /^[A-Za-z0-9_]+$/, :on => :create, :message => "hashtag can only contain letters and numbers"
  validate :user_can_edit_event?
  
  def add_user_by_twitter_name(twitter_name)
    user = User.find_by_twitter_name(User.filter_at(twitter_name))
    user ||= User.create_user(twitter_name)
    self.users << user unless self.users.include? user
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
  
  def participants
    tweets = Event.pull_recent_tweets(self.name, 200)    
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
      
  def Event.filter_hash(event_name)
    event_name.slice!(0) if event_name[0,1] == '#'    
    event_name
  end
  
  def Event.find_by_description description
    Event.find(:all,
               :joins => :event_data,
               :conditions => ["event_data.event_data_type_id = ? and event_data.description like ?", 2, "%" + description + "%"])
  end

  def Event.find_by_title title
    Event.find(:all,
               :joins => :event_data,
               :conditions => ["event_data.event_data_type_id = ? and event_data.description like ?", 1, "%" + title + "%" ])
  end
  
  def Event.create_event(event_data, twitter_name)
    event = Event.new(event_data)
    user = User.find_by_twitter_name(twitter_name)    
    event.last_updated_by = twitter_name
    event.users << user
    event.name = Event.filter_hash(event.name)    
    event.creator = user
    event.save
    event
  end
  
  def Event.pull_recent_tweets(tag,num = nil,since = nil)
    html = ""
    twitter = Net::HTTP.start('search.twitter.com')
    command = "/search.json?" + "q=" + URI.escape("#{tag}")
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
    
    json_result = Array.new()
    result["results"].each do |j|
        json_result.push(j)
    end

    json_result
  end
  
  private
  
  def get_data_item(name)    
    items = self.event_data.select do |data|
      data.event_data_type.name == name
    end
    if (!items.nil? && items.length > 0)
      return items[0].description
    else
      return ""
    end
  end
    
  def user_can_edit_event?
    user = User.find_by_twitter_name(self.last_updated_by)    
    return true
  end
end
