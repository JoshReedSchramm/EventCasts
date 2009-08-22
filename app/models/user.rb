class User < ActiveRecord::Base
  include Clearance::App::Models::User

  has_and_belongs_to_many :groups

 # attr_accessible :atoken, :asecret
  
end
