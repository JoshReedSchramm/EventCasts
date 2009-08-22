class AddDefaultUserAndGroup < ActiveRecord::Migration
  def self.up
    default_account = User.create(:twitter_name=>'asktwoups')
    default_account.save!
    
    group = Group.create(:name=>'twoups')
    group.save!
    
    default_account.groups << group
    default_account.save!
  end

  def self.down
    User.delete_all
    Group.delete_all
  end
end
