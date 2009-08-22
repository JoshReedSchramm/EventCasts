class GroupsController < ApplicationController
  def new
    @group = Group.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  def create
    @group = Group.new(params[:group])
    @group.add_user_by_twitter_name(session[:twitter_name])    
    @group.name = Group.filter_hash(@group.name)

    respond_to do |format|
      if @group.save
        flash[:notice] = 'Group was successfully created.'
        format.html { redirect_to :controller=>"user", :action=>"home" }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
  def show
    @group = Group.find_group_from_heirarchy(params[:group_names])
    if (@group.nil?)
        flash[:notice] = 'Could not find the group.'      
    end
  end  
end
