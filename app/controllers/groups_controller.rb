class GroupsController < ApplicationController
  def new
    @group = Group.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  def set_data    
    @group_data = GroupDatum.new(params[:group_datum]) 
    existing_data_item = GroupDatum.find(:first, :conditions=>["group_id=? and group_data_type_id=?", @group_data.group_id, @group_data.group_data_type_id])
    if (!existing_data_item.nil?)   
      existing_data_item.description = @group_data.description
      @group_data = existing_data_item
    end
    @group = Group.find(@group_data.group_id)
    if User.can_edit_group?(@group, session[:twitter_name])
      @group_data.save    
      respond_to do |format|
        format.html 
        format.json  { render :json => @group_data.to_json }
        format.js { render :partial=> "set_data" }
      end
    end
  end
  
  def create
    if (session[:twitter_name].nil? || session[:twitter_name].blank? )
      return
    end
    
    @group = Group.new(params[:group])
    @group.add_user_by_twitter_name(session[:twitter_name])    
    @group.name = Group.filter_hash(@group.name)
    
    if (@group.parent_id != 0)
      @parent = Group.find(@group.parent_id)
      allowed = User.can_edit_group?(@parent, session[:twitter_name])      
    else
      allowed = true
    end
    
    if allowed
      user = User.find_by_twitter_name(session[:twitter_name])
      if !user.nil?
        @group.creator_id = user.id
      end
      if @group.save
        if (@group.parent_id == 0)
          @user = User.find_by_twitter_name(session[:twitter_name])
          @user.groups.each do |ug|
            ug.sub_groups = ug.populate_sub_group
          end
          @sub_groups = @user.groups
          @error_messages = get_error_descriptions(@group.errors)
          render :layout => false
        else
          @group = @parent
          populate_sub_group(@group)    
          @sub_groups = @group.sub_groups
          render :layout => false
        end
      else      
        @error_messages = get_error_descriptions(@group.errors)
        render :layout => false      
      end
    end
  end

  def add_group_vip
    @group = Group.find_group_from_heirarchy(params[:group_names])
    user = params[:user]

    if !@group.nil?
      if (@group.parent_id != 0)
        @parent = Group.find(@group.parent_id)
        allowed = User.can_edit_group?(@parent, session[:twitter_name])
      else
        allowed = true
      end

      if allowed
        @group.add_user_by_twitter_name(user[:twitter_name])
        @group.save!
      else
        @error_messages = get_error_descriptions(@group.errors)
        render :layout => false
      end
    else
      @error_messages = get_error_descriptions(@group.errors)
      render :layout => false
    end
  end
  
  def show
    @group = Group.find_group_from_heirarchy(params[:group_names])
    @vip_user = User.new()

    num = params[:num]
    since = params[:since_id]
    if (@group.nil?)
      @group = Group.new()
      @group.sub_groups = Array.new()

      unknown_path = "";
      if !params[:group_names].nil?
        unknown_path = params[:group_names].join('/')
        @group.name = params[:group_names][0]
      end

      respond_to do |format|
        format.html
        format.json { render :json => recent_tweets(unknown_path,num,since).to_json }
        format.js { render :partial=> "results" }
      end
    else
      populate_sub_group(@group)

      respond_to do |format|
        format.html
        format.json { render :json => recent_tweets(@group.get_full_path,num,since).to_json }
        format.js { render :partial=> "results" }
      end
    end
  end

  def recent_tweets(full_group_name,num = nil,since = nil)
    pull_recent_tweets(full_group_name,num,since)
  end


  def populate_sub_group(group)
    @sub_groups = Group.find_all_by_parent_id(group.id)
    unless @sub_groups == nil
      group.sub_groups = Array.new()
      @sub_groups.each do |g|
        group.sub_groups.push(g)
        #too agressive
        #populate_sub_group(g)
      end
    end
  end

  private

  def pull_recent_tweets(tag,num = nil,since = nil)
    # assume the user passes the full tag

    html = ""
    logger.debug("Got #{tag}")
    @terms = tag.split('/')
    @search = ""
    @match = ""
    @terms.each do |t|
      @search << "+##{t}"
      @match << "##{t} "
    end
    #remove trailing space
    @match.chop!

    logger.debug("Searching for #{@search}")
    logger.debug("Matching on #{@match}")


    twitter = Net::HTTP.start('search.twitter.com')
    # Set the form data with options
    command = "/search.json?" + "q=" + URI.escape("#{@search}")
    command << "&" + "per_page=" + num.to_s if !num.nil?
    command << "&" + "since_id=" + since.to_s if !since.nil?
    command << "&refresh=true" if !num.nil? || !since.nil?

    logger.debug("Request URI: " + command)

    req = Net::HTTP::Get.new(command)

    res = twitter.request(req)

    # Raise an exception unless Twitter
    # returned an OK result
    unless res.is_a? Net::HTTPOK
      html << res.body
    end

    result = JSON.parse(res.body)
    
    regex_to_build = @match.split(' ')
    regex_match = ""
    regex_to_build.each do |r|
      regex_match << r
      regex_match << "\\s*"
    end

    json_result = Array.new()
    result["results"].each do |j|
      logger.debug("Got: "+j["text"])
      if j["text"] =~ /#{regex_match}/
        json_result.push(j)
      end
      logger.debug(regex_match)      
    end

    json_result
  end
end
