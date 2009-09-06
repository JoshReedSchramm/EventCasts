class GroupDatum < ActiveRecord::Base
  validate :editor_can_edit
  
  belongs_to :group_data_type
  belongs_to :group
  
  def GroupDatum.create_or_update(data, user)    
    group_data = GroupDatum.find(:first, :conditions=>["group_id=? and group_data_type_id=?", data[:group_id], data[:group_data_type_id]])
    if group_data.nil?
      group_data = GroupDatum.new(data)
    else
      group_data.update_attributes(data)
    end
    group_data.last_updated_by = user        
    group_data
  end
  
  private
  
  def editor_can_edit
    user = User.find_by_twitter_name(self.last_updated_by)
    Security.can_edit_group?(user, self.group)    
  end
end
