class AddEventDataTypes < ActiveRecord::Migration
  def self.up
    EventDataType.create(:name=>'title').save!
    EventDataType.create(:name=>'description').save!
    EventDataType.create(:name=>'url').save!  end
  def self.down
    EventDataType.delete_all    
  end
end
