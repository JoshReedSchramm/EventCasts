class AddCreateToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :creator_id, :integer, {:default=>0}
  end

  def self.down
    remove_column :creator_id
  end
end
