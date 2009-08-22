class AddDefaultGroupData < ActiveRecord::Migration
  def self.up
    description = GroupDataType.find_by_name('description')
    group = Group.find(1)
    
    gd = GroupData.new()
    gd.group_data_type = description
    gd.group = group
    gd.description = "Sample Description"
    
    gd.save!
    
  end

  def self.down
    GroupData.delete_all
  end
end
