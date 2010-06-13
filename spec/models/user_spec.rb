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
  it "requires username" do
    lambda do
      p = User.create(:ec_username=>nil, :password=>"password")
      p.errors[:ec_username].should_not be_empty
      p.errors[:password].should be_empty
    end.should_not change { User.count }
  end
  it "requires a unique username" do
    lambda do
      p1 = User.create(:ec_username=>"testusername", :password=>"password")
      p2 = User.create(:ec_username=>"testusername", :password=>"password")
      p1.errors[:ec_username].should be_empty
      p2.errors[:ec_username].should_not be_empty
    end.should change { User.count }.by(1)
  end
  it "requires password" do
    lambda do
      p = User.create(:ec_username=>"username", :password=>nil)
      p.errors[:ec_username].should be_empty
      p.errors[:password].should_not be_empty
    end.should_not change { User.count }
  end
end