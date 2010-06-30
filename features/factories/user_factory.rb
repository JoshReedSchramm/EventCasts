Factory.define :eventcasts, :class=>User do |u|
  u.ec_username 'eventcasts'
  u.password 'password'
end

Factory.define :twitter_user, :class=>User do |u|
  u.ec_username 'eventcasts'
  u.password 'password'  
  u.associated_accounts { |account| [account.association(:associated_account)]}
end