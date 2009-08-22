class CreateGroupDataTypes < ActiveRecord::Migration
  def self.up
    create_table :group_data_types do |i| 
      i.string :name
      i.timestamps
    end
  end

  def self.down
    drop_table :group_data_types
  end

end
