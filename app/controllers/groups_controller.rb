class GroupsController < ApplicationController
  before_filter :authorize, :except=>[:vips, :participants, :show, :recent_tweets]
  
  def new
    @group = Group.new    
    respond_to do |format|
      format.html
    end
  end
  
  def set_data 
    group_data = GroupDatum.create_or_update(params[:group_datum])   
    return if !Security.can_edit_group?(User.find_by_twitter_name(session[:twitter_name]), group_data.group)
    group_data.save
    respond_to do |format|
      format.json  { render :json => group_data.to_json }
    end
  end
  
  def create
    @group = Group.create_group(params[:group], session[:twitter_name])
    
    if !@group.errors.empty?
      if request.xhr?
        response.headers['X-JSON'] = @group.errors.to_json
      end
      render :layout => false, :status=>444
      return
    end

    if (@group.parent.nil?)
      redirect_to :controller=>"user", :action=>"groups", :twitter_name=>session[:twitter_name]
    else
      redirect_to :controller=>"groups", :action=>"group_heirarchy", :id=>@group.parent.id
    end
  end
  
  def group_heirarchy
    @group = Group.find(params[:id])
    @owner = @group
    render :layout => false
  end

  def add_group_vip
    user = params[:user]
    @group = Group.find_by_id(user[:group_id])
    @error_messages = ""

    return if @group.nil?
    return if !Security.can_edit_group? User.find_by_twitter_name(session[:twitter_name]), @group

    if !@group.add_user_by_twitter_name?(User.filter_at(user[:twitter_name]),true)
      @error_messages = "user is already a VIP"
    else
      @group.save!
    end
    render :layout => false
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
    @owner = @group
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

  protected

  def authorize
    unless Security.is_authenticated?(session[:twitter_name])
      redirect_to(:controller=>"home", :action=>"index")
      false
    end
  end
end
