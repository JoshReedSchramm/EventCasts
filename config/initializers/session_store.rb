# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_TwoupsProject_session',
  :secret      => '569266dba4bc1345380eecddd37645408263145865c29416fb275a7369cf86f1b6bc608f80f239b9eb8731648152f4806f54174cfb8776abd714c0a8c169055e'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
