class AssociatedAccount < ActiveRecord::Base
  belongs_to :associated_account_type
  
  scope :twitter, where(:associated_account_type_id => 1)
  scope :has_username, lambda { |username| where(:username => username) }
end
