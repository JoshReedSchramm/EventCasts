class CreateGroupData < ActiveRecord::Migration
  def self.up
    create_table :group_data do |i| 
      i.integer :group_data_type_id
      i.integer :group_id
      i.string :description
      i.string :last_updated_by
      i.timestamps
    end
  end

  def self.down
    drop_table :group_data
  end
end
