require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GroupsController do
  it "should use GroupsController" do
    controller.should be_an_instance_of(GroupsController)
  end

  context "When an anonymous user visits the site" do
    %w[new set_data create add_group_vip].each do |action|
      it "#{action} should redirect the user to the home page" do
        Security.stub!(:is_authenticated?).and_return false
        get action
        response.should redirect_to(:controller => "home", :action => "index")
      end
    end
  end
end
