class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |i| 
      i.string :name
      i.integer :parent_id
      i.string :last_updated_by
      i.timestamps
    end
  end

  def self.down
    drop_table :groups
  end
end
