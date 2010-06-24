class CreateAssociatedAccountTypes < ActiveRecord::Migration
  def self.up
    create_table :associated_account_types do |t|
      t.string :name
      t.string :abbreviation
      t.timestamps
    end
    
    twitter = AssociatedAccountType.create(:name=>'Twitter', :abbreviation=>'TW')
    twitter.save
    
  end

  def self.down
    drop_table :associated_account_types
  end
end
