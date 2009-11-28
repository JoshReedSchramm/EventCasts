class AddDefaultGroupData < ActiveRecord::Migration
  def self.up
    description = GroupDataType.find_by_name('description')
    group = Group.find(1)
    
    gd = GroupDatum.new()
    gd.group_data_type = description
    gd.group = group
    gd.description = "Sample Description"
    puts gd.nil?    
  end

  def self.down
    GroupDatum.delete_all
  end
end
