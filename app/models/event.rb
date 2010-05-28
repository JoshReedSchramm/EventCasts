class Event < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :search_terms
  has_many :messages, :limit=>10, :order=>"created desc"
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"

  validates_presence_of :name, :on => :create, :message => "can't be blank"
  validates_format_of :name, :with => /^[A-Za-z0-9_ ]+$/, :on => :create, :message => "can only contain letters and numbers"
  validate :user_can_edit_event?
  validate :at_least_one_search_term?, :message=>"At least one search terms is required"

  HUMANIZED_ATTRIBUTES = {
    :name => "Event Name"
  }

  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
 
  def Event.filter_hash(event_name)
    event_name.slice!(0) if event_name[0,1] == '#'    
    event_name
  end
  
  def Event.create_event(params, user)
    event = Event.new(params[:event])
    event.creator_id = user.id
    params[:search_terms].each do |term|
      event.search_terms << SearchTerm.new({:term=>term})
    end unless params[:search_terms].nil?
    event   
  end

  private
      
  def user_can_edit_event?
    user = User.find_by_twitter_name(self.last_updated_by)    
    return true
  end

  def at_least_one_search_term?
    errors[:base] << "At least one search term must be provided" if self.search_terms.empty?      
  end
end
