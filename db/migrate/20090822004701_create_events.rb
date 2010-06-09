class CreateEvents  < ActiveRecord::Migration
  def self.up
    create_table :events do |i| 
      i.string :name
      i.string :description
      i.string :url
      i.string :last_updated_by
      i.integer :creator_id, :default=>0      
      i.timestamps
    end
  end

  def self.down
    drop_table :events    
  end
end
