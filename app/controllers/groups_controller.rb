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

    populate_sub_group(@group)

  end

private
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
end
