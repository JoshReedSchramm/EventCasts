class CreateGroupsUsers < ActiveRecord::Migration
  def self.up
    create_table :groups_users do |i| 
      i.integer :group_id
      i.integer :user_id      
      i.timestamps
    end
  end

  def self.down
    drop_table :groups_users
  end
end
