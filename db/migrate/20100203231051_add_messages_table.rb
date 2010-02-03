class AddMessagesTable < ActiveRecord::Migration
  def self.up
     create_table :messages do |t|
       t.integer :event_id
       t.string :original_id
       t.string :from_user
       t.string :origin_url
       t.string :text
       t.string :profile_image_url
       t.datetime :created
       t.string :source
       t.timestamps
      end
  end

  def self.down
    drop_table :messages
  end
end
