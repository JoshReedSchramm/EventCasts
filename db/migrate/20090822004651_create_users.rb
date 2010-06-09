class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |i| 
      i.string :ec_username
      i.string :hashed_password
      i.string :salt   
      i.string :profile_image_url   
      i.string :email            
      i.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
