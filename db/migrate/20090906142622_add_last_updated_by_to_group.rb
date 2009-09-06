class AddLastUpdatedByToGroup < ActiveRecord::Migration
  def self.up
    add_column :groups, :last_updated_by, :string        
  end

  def self.down
    remove_column :groups, :last_updated_by            
  end
end
