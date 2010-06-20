class User < ActiveRecord::Base
  has_and_belongs_to_many :events
  has_many :associated_accounts
  has_many :created_events, :class_name => "Event", :foreign_key => "creator_id"

  validates :ec_username, :uniqueness => true
    
  scope :twitter_account, lambda { |username| joins(:associated_accounts) & AssociatedAccount.twitter & AssociatedAccount.has_username(username) }
    
  def self.get_from_twitter(profile)
    user = User.twitter_account(profile.screen_name).first
    user = create_user_from_twitter(profile) if user.nil?
    user
  end
  
  def self.authenticate(name, password)
    user = self.find_by_ec_username(name)
    if user
      expected_password = encrypted_password(password, user.salt)      
      user = nil if user.hashed_password != expected_password
    end
    user
  end
  
  def password
    @password
  end
  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = User.encrypted_password(self.password, self.salt)
  end
  
  def display_name    
    ec_username || "@"+twitter_account.username || ""
  end
  
  def twitter_account
    associated_accounts.select { |x| x.service == "TW"}.first
  end
    
  private 
      
  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
  
  def self.encrypted_password(password, salt)
    string_to_hash = password + "eventcasts" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end  
  
  def self.create_user_from_twitter(profile)
    user = User.new(:ec_username=>nil, :password=>nil)
    user.associated_accounts << AssociatedAccount.new(:username => profile.screen_name, :service=>"TW")
    user.save!
    user
  end
end
