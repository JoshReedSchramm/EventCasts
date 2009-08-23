class User < ActiveRecord::Base
  has_and_belongs_to_many :groups
  validates_presence_of :twitter_name, :on => :create, :message => "can't be blank"

  def authorized?
    !atoken.blank? && !asecret.blank?
  end 
  
  def User.can_edit_group?(group, twitter_name)
    if (twitter_name.nil? || twitter_name.empty?)
      return false;
    end
    user = User.find_by_twitter_name(twitter_name)    
    
    if (user.nil?)
      return false
    end
    
    user.groups.select do |g|
      g.id == group.id
    end.length > 0    
  end
  
  def get_twitter_profile
    ha = Twitter::HTTPAuth.new('twoupsinfo', 'vMxzWUmylHJf')
    base = Twitter::Base.new(ha)    
    base.user(self.twitter_name)
  rescue
    return self
  end
end
