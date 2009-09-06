module GroupsHelper
  
  private 
  
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
