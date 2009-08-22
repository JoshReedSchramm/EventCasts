class UserController < ApplicationController
  def home
    session[:twitter_name]='asktwoups'
    @user = User.find_by_twitter_name(session[:twitter_name]) 
  end

  def login
    #store_request_token oauth.request_token(:oath_callback => 'http://0.0.0.0:3000/user/authorize')
    #redirect_to oauth.request_token.authorize_url

    
    request_token = consumer.get_request_token
    store_request_token request_token
    redirect_to request_token.authorize_url(:oauth_callback => 'http://0.0.0.0:3000/user/authorize')
  end

  def authorize
    request_token = get_request_token
    access_token = request_token.get_access_token
    #consumer.authorize_from_request(session['rtoken'], session['rsecret'])
    @response = consumer.request(:get, '/account/verify_credentials.json', access_token, {:scheme => :query_string})
    clear_request_token

    case @response
      when Net::HTTPSuccess
        user_info = JSON.parse @response_body
        unless user_info['screen_name']
          flash[:notice] = "Authentication failed"
          redirect_to :action => :home
          return
        end

        user_name = user_info['screen_name']
        session[:twitter_name] = user_name
        user = User.find_all_by_twitter_name user_name
        user.atoken = consumer.access_token.token
        user.secret = consumer.access_token.asecret
        user.save!

        redirect_to :action => :home
      else
        flash[:notice] = "Authentication failed"
        redirect_to :action => :home
    end
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

  def get_request_token
    OAuth::RequestToken.new(consumer, session['rtoken'], session['rsecret'])
  end
 end
