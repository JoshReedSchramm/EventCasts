module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'
    when /the login page/
      '/user/login'
    when /the sign up page/
      '/user/register'
    when /the user home page/
      '/user/home'
    when /the twitter oauth page/
      '/oauth/authenticate'            
    when /the twitter signin complete page/
      '/associated_account/finalize_twitter'
    when /the associated accounts page/
      '/user/accounts'      
    else      
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
  
  def link_names(link_name)
    case link_name

    when /Associate a new account/
      'associate_account'
    when /Add a twitter account/
      'show_associate_TW'
    when /Add a eventcasts account/
      'show_associate_EC'
    when /login with twitter/
      'twitter_login'      
    else      
      begin
        link_name =~ /the (.*) link/
        link_components = $1.split(/\s+/)
        self.send(link_components.push('link').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{link_name}\" to a link.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
