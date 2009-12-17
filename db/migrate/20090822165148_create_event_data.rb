class CreateEventData < ActiveRecord::Migration
  def self.up
    create_table :event_data do |i| 
      i.integer :event_data_type_id
      i.integer :event_id
      i.string :description
      i.string :last_updated_by
      i.timestamps
    end
  end

  def self.down
    drop_table :event_data
  end
end
