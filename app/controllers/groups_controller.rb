class GroupsController < ApplicationController
  before_filter :authorize, :except=>[:vips, :participants, :show, :recent_tweets]
  
  def new
    @group = Group.new    
    respond_to do |format|
      format.html
    end
  end
  def create
    @group = Group.create_group(params[:group], session[:twitter_name])    
    return if handle_ajax_validation_errors(@group)
    if (@group.parent.nil?)
      redirect_to :controller=>"user", :action=>"groups", :twitter_name=>session[:twitter_name]
    else
      redirect_to :controller=>"groups", :action=>"group_heirarchy", :id=>@group.parent.id
    end
  end
  
  def set_data 
    group_data = GroupDatum.create_or_update(params[:group_datum], session[:twitter_name])   
    group_data.save
    respond_to do |format|
      format.json  { render :json => group_data.to_json }
    end unless handle_ajax_validation_errors(group_data)    
  end
  
  def group_heirarchy
    @group = Group.find(params[:id])
    respond_to do |format|
      format.html  { render :layout=>false }
    end
  end

  def add_group_vip
    user = params[:user]

    @group = Group.find_by_id(user[:group_id])
    return if @group.nil?
    @group.last_updated_by = session[:twitter_name]

    @group.add_user_by_twitter_name(user[:twitter_name])
    @group.save!
    
    respond_to do |format|
      format.html { render :layout => false }       
    end unless handle_ajax_validation_errors(@group)
  end

  def vips
    @group = Group.find(params[:group_id])
    @vips = @group.get_vips
    respond_to do |format|
       format.html { render :layout => false }       
     end
  end
  
  def participants
    @group = Group.find(params[:group_id])
    respond_to do |format|
       format.html { render :layout => false }       
     end 
  end
  
  def show
    @vip_user = User.new()
    @path = params[:group_names].join('/')
    @group = get_group_for_display(params[:group_names])
    respond_to do |format|
      format.html
      format.json { render :json =>  Group.pull_recent_tweets(@group.full_path,params[:num],params[:since_id]).to_json }
      format.js { render :partial=> "results" }
    end
  end

  protected  
  
  def get_group_for_display(group_names)
    group = Group.find_group_from_heirarchy(group_names)
    if group.nil?
      group = Group.new()
      unknown_path = "";
      if !group_names.nil?
        unknown_path = group_names.join('/')
        group.name = group_names[0]
      end
      group.full_path = unknown_path
    end
    group
  end  
end