class CreateEventsUsers < ActiveRecord::Migration
  def self.up
    create_table :events_users, :id => false do |i| 
      i.integer :event_id
      i.integer :user_id 
      i.string :last_updated_by     
      i.timestamps
    end
  end

  def self.down
    drop_table :events_users    
  end
end
