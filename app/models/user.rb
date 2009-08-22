class User < ActiveRecord::Base
  has_and_belongs_to_many :groups  
  validates_presence_of :twitter_name, :on => :create, :message => "can't be blank"
  
end
