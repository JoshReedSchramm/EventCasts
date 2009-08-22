class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |i| 
      i.string :twitter_name
      i.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
