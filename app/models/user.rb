class User < ActiveRecord::Base
  has_and_belongs_to_many :events
  validates_presence_of :ec_username
  validates_uniqueness_of :ec_username
  
  validate :password_non_blank
  
  def password
    @password
  end
  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = User.encrypted_password(self.password, self.salt)
  end
  
  def self.authenticate(name, password)
    user = self.find_by_ec_username(name)
    if user
      expected_password = encrypted_password(password, user.salt)      
      user = nil if user.hashed_password != expected_password
    end
    user
  end
    
  def twitter_profile
    if @twitter_profile.nil?
      ha = Twitter::HTTPAuth.new('eventcasts', 'StartupsFTW!')
      base = Twitter::Base.new(ha)    
      @twitter_profile = base.user(self.twitter_name)    
    end
    @twitter_profile
  rescue
    return nil
  end
  
  def User.filter_at(user_name)
    user_name.slice!(0) if user_name[0,1] == '@'    
    user_name
  end
  
  private 
  
  def password_non_blank
    errors.add(:password, "Missing password") if hashed_password.blank?
  end
    
  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
  
  def self.encrypted_password(password, salt)
    string_to_hash = password + "eventcasts" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end
end
