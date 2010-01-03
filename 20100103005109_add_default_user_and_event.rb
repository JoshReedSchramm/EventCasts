class AddDefaultUserAndEvent < ActiveRecord::Migration
  def self.up
    default_account = User.create(:username=>'asktwoups', :password=>'password')
    default_account.save!
        
    event = Event.create(:name=>'twoups')
    event.save
    
    default_account.events << event
    default_account.save!
  end

  def self.down
    User.delete_all
    Event.delete_all
  end
end
