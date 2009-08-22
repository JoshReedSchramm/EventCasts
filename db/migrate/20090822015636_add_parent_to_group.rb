class AddParentToGroup < ActiveRecord::Migration
  def self.up
    add_column :groups, :parent_id, :integer, {:default=>0}
  end

  def self.down
    remove_column :parent_id
  end
end
