When /^Twitter authorizes me$/ do
  FakeWeb.allow_net_connect = false
  FakeWeb.register_uri(:post, 'http://api.twitter.com/oauth/request_token', :body => 'oauth_token=fake&oauth_token_secret=fake')
  FakeWeb.register_uri(:post, 'http://api.twitter.com/oauth/access_token', :body => 'oauth_token=fake&oauth_token_secret=fake')
  FakeWeb.register_uri(:get, 'http://api.twitter.com/1/account/verify_credentials.json', :response => File.join(Rails.root, 'features', 'fixtures', 'verify_credentials.json'))  
  visit path_to("the twitter signin complete page")
end

When /^Twitter rejects me$/ do
  FakeWeb.allow_net_connect = false
  FakeWeb.register_uri(:post, 'http://api.twitter.com/oauth/request_token', :body => 'oauth_token=fake&oauth_token_secret=fake')
  FakeWeb.register_uri(:post, 'http://api.twitter.com/oauth/access_token', :body => 'oauth_token=fake&oauth_token_secret=fake')
  FakeWeb.register_uri(:get, 'http://api.twitter.com/1/account/verify_credentials.json', :response => File.join(Rails.root, 'features', 'fixtures', 'verify_credentials_invalid.json'))  
  visit path_to("the twitter signin complete page")
end