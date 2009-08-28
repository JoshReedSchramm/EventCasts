class GroupDatum < ActiveRecord::Base
  belongs_to :group_data_type
  belongs_to :group
  
  def GroupDatum.create_or_update(data)    
    group_data = GroupDatum.find(:first, :conditions=>["group_id=? and group_data_type_id=?", data[:group_id], data[:group_data_type_id]])
    if group_data.nil?
      group_data = GroupDatum.new(data)
    else
      group_data.update_attributes(data)
    end
    group_data
  end
end
