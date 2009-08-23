class UserController < ApplicationController
  def home
    redirect_to :action => :login unless session[:twitter_name]
    @user = User.find_by_twitter_name(session[:twitter_name])
    @user.groups.each do |ug|
      ug.sub_groups = ug.populate_sub_group
    end
  end

  def login
    store_request_token login_request_token
    redirect_to login_request_token.authorize_url
  end

  def authorize
    verification_response = verify_credentials
    clear_request_token

    unless verification_response.is_a? Net::HTTPSuccess
      handle_failed_authorization
      return
    end

    user_info = JSON.parse(verification_response.body)

    unless user_info['screen_name']
      handle_failed_authorization
      return
    end

    user_name = user_info['screen_name']
    session[:twitter_name] = user_name
    update_user user_name
    redirect_to :action => :home
  end

  def oauth
    @oauth ||= Twitter::OAuth.new(ConsumerConfig['token'], ConsumerConfig['secret'])
  end

  def consumer
    @consumer ||= OAuth::Consumer.new(ConsumerConfig['token'], ConsumerConfig['secret'], {:site => 'http://twitter.com'})
  end

  def store_request_token(request_token)
    session['rtoken'] = request_token.token
    session['rsecret'] = request_token.secret
  end

  def clear_request_token
    session['rtoken'] = nil
    session['rsecret'] = nil
  end

  def login_request_token
    @login_rtoken ||= consumer.get_request_token
  end

  def authorization_request_token
    @authorization_rtoken ||= OAuth::RequestToken.new(consumer, session['rtoken'], session['rsecret'])
  end

  def access_token
     @atoken ||= authorization_request_token.get_access_token
  end

  def verify_credentials
    consumer.request(:get, '/account/verify_credentials.json', access_token, {:scheme => :query_string})
  end

  def update_user user_name
    user = User.find_by_twitter_name(user_name)

    if user.nil?
      user = User.new
      user.twitter_name = user_name
    end

    user.atoken = access_token.token
    user.asecret = access_token.secret
    user.save!
  end

  def handle_failed_authorization
    flash[:notice] = "Authentication failed"
    redirect_to :controller => :home, :action => :index
  end
 end
