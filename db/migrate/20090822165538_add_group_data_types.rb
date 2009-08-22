class AddGroupDataTypes < ActiveRecord::Migration
  def self.up
    GroupDataType.create(:name=>'title').save!
    GroupDataType.create(:name=>'description').save!
    GroupDataType.create(:name=>'url').save!
  end

  def self.down
    GroupDataType.delete_all    
  end
end
