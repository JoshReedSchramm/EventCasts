class GroupsController < ApplicationController
  def new
    @group = Group.new
    respond_to do |format|
      format.html
    end
  end
  
  def set_data 
    group_data = GroupDatum.create_or_update(params[:group_datum])   

    if User.can_edit_group?(group_data.group, session[:twitter_name])
      group_data.save    
      respond_to do |format|
        format.json  { render :json => group_data.to_json }
      end
    end
  end
  
  def create
    if (session[:twitter_name].nil? || session[:twitter_name].blank? )
      return
    end
    @sub_groups = nil
    @group = Group.new(params[:group])
    @group.add_user_by_twitter_name?(session[:twitter_name])
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
          @parent_check_id = 0
          render :layout => false
        else
          @group = @parent
          populate_sub_group(@group)  
          @group.sub_groups.each do |sg|
            sg.sub_groups = sg.populate_sub_group
          end  
          @sub_groups = @group.sub_groups
          @parent_check_id = @group.id
          render :layout => false
        end
      else      
        @error_messages = get_error_descriptions(@group.errors)
        render :layout => false      
      end
    end
  end

  def add_group_vip
    user = params[:user]
    @group = Group.find_by_id(user[:group_id])
    @error_messages = ""

    if !@group.nil?
      if (@group.parent_id != 0)
        @parent = Group.find(@group.parent_id)
        allowed = User.can_edit_group?(@parent, session[:twitter_name])
      else
        allowed = true
      end

      if allowed        
        if !@group.add_user_by_twitter_name?(User.filter_at(user[:twitter_name]),true)
          @error_messages = "user is alread a VIP"
        else
          @group.save!
          @vips = @group.get_vips
        end
        render :layout => false
      else
        @error_messages = get_error_descriptions(@group.errors)
        render :layout => false
      end
    else
      @error_messages = get_error_descriptions(@group.errors)
      render :layout => false
    end
  end
  
  def vips
    @group = Group.find(params[:group_id])
    @vips = @group.get_vips
    render :layout => false
  end
  
  def participants
    @group = Group.find(params[:group_id])
    @participants = @group.participants    
    render :layout => false    
  end
  
  def show
    @error_messages = ""
    @group = Group.find_group_from_heirarchy(params[:group_names])
    @vips = @group.get_vips if !@group.nil?
    @participants = @group.participants if !@group.nil?
    @sub_groups = nil
    
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
      @group.sub_groups.each do |sg|
        sg.sub_groups = sg.populate_sub_group
      end
      @parent_check_id = @group.id      
      @sub_groups = @group.sub_groups

      respond_to do |format|
        format.html
        format.json { render :json => recent_tweets(@group.get_full_path,num,since).to_json }
        format.js { render :partial=> "results" }
      end
    end
  end

  def recent_tweets(full_group_name,num = nil,since = nil)
    Group.pull_recent_tweets(full_group_name,num,since)
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

  
end
