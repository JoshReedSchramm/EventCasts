class AssociatedAccount < ActiveRecord::Base
  scope :twitter, where(:service => "TW")
  scope :has_username, lambda { |username| where(:username => username) }
end
