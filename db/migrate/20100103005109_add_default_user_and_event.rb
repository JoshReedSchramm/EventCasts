class AddDefaultUserAndEvent < ActiveRecord::Migration
  def self.up
    default_account = User.create(:username=>'asktwoups', :password=>'password')
    default_account.save!
    
    search_term = SearchTerm.create(:term=>'twoups')
        
    event = Event.create(:name=>'twoups', :search_terms=>[search_term])
    event.save
    
    default_account.events << event
    default_account.save!
  end

  def self.down
    User.delete_all
    Event.delete_all
  end
end
