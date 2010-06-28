class AssociatedAccountController < ApplicationController  
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
    @account_types_to_show = []
    
    @account_types_to_show << AssociatedAccountType.new(:name=>"eventcasts", :abbreviation=>"EC") if logged_in_user.ec_username.nil?

		AssociatedAccountType.all.each do |account_type| 				
			@account_types_to_show << account_type if (!logged_in_user.has_account_type(account_type.id))
		end
		
    respond_to do |format|
      format.html
    end
  end
end
