class CreateAssociatedAccounts < ActiveRecord::Migration
  def self.up
    create_table :associated_accounts do |t|
      t.integer :user_id
      t.string :username      
      t.integer :associated_account_type_id
      t.timestamps
    end
  end

  def self.down
    drop_table :associated_accounts    
  end
end
