class AssociatedAccountController < ApplicationController  
  include AssociatedAccountHelpers
  
  def start_twitter
      oauth.set_callback_url(finalize_twitter_session_url)

      session['rtoken']  = oauth.request_token.token
      session['rsecret'] = oauth.request_token.secret

      redirect_to oauth.request_token.authorize_url
  end
  
  def finalize_twitter
    oauth.authorize_from_request(session['rtoken'], session['rsecret'], params[:oauth_verifier])
    profile = Twitter::Base.new(oauth).verify_credentials            
    
    if profile        
      session['rtoken'] = session['rsecret'] = nil
      session[:atoken] = oauth.access_token.token
      session[:asecret] = oauth.access_token.secret

      if session[:user].nil?
        session[:user] = User.get_from_twitter(profile)
      else
        user = session[:user]
        user.associate_account(profile.screen_name, 1)
        user.save
      end
      
      redirect_to :controller=>"user", :action=>"home"
    end
  end  
  
  def add
    generate_account_types_to_show
    respond_to do |format|
      format.html
    end
  end
  
  def associate_eventcasts
    user = User.update(session[:user].id, params[:user])    
    @updated_user = user
    if (user.errors.blank?)      
      redirect_to :controller=>"user", :action=>"accounts"
    else      
      generate_account_types_to_show
      render :controller=>"associated_account", :action=>"add"
    end    
  end  
  
  def remove
    AssociatedAccount.delete(params[:id])
    if request.xhr?
      render :controller => "user", :action=>"accounts", :layout=>false
    else
      redirect_to :controller=>"user", :action=>"accounts"
    end    
  end
end
