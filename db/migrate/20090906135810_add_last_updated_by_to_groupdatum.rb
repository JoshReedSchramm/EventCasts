class AddLastUpdatedByToGroupdatum < ActiveRecord::Migration
  def self.up
    add_column :group_data, :last_updated_by, :string    
  end

  def self.down
    remove_column :group_data, :last_updated_by        
  end
end
