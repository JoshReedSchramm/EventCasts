class CreateAssociatedAccounts < ActiveRecord::Migration
  def self.up
    create_table :associated_accounts do |t|
      t.integer :user_id
      t.string :username      
      t.string :service, :default=>'TW'
      t.timestamps
    end
  end

  def self.down
    drop_table :associated_accounts
  end
end
