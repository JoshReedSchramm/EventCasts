require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  subject do
    User.new({:ec_username=>"Eventcasts", :password=>"password"}).tap do |s|
      s.save
    end
  end    
  it { should be_valid } 
  its(:errors) { should be_empty }
  its(:hashed_password) { should_not be_nil}
  it "has many associated accounts" do
    association = User.reflect_on_association(:associated_accounts)
    association.should_not be_nil
    association.macro.should == :has_many
  end
  it "requires a unique username" do
    lambda do
      p1 = User.create(:ec_username=>"testusername", :password=>"password")
      p2 = User.create(:ec_username=>"testusername", :password=>"password")
      p1.errors[:ec_username].should be_empty
      p2.errors[:ec_username].should_not be_empty
    end.should change { User.count }.by(1)
  end
end

describe User do
  context "when logging in through Twitter" do

    let (:mock_twitter_profile) { mock(Twitter::Request, {:screen_name=>"Eventcasts"})}
    subject { User.get_from_twitter(mock_twitter_profile) }    

    context "and it is the first time" do
      it "should create an account" do
        User.should_receive(:twitter_account).and_return([])
        subject.associated_accounts.count.should == 1
        subject.associated_accounts.twitter.first.username.should == "Eventcasts"
      end
    end  
    context "and they have an existing twitter account" do      
      it "return the existing account" do
        mock_associated_account = mock_model(AssociatedAccount, :username=>"Eventcasts", :service=>"TW")
        mock_user = mock_model(User, {:associated_accounts=>[mock_associated_account]})
        User.should_receive(:twitter_account).and_return([mock_user])
        User.should_not_receive(:save!)
        subject.associated_accounts.count.should == 1
      end
    end          
  end
end