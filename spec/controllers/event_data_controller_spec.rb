require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EventDataController do
  def mock_event_data(stubs={})
    @mock_event_data ||= mock(EventDatum, stubs)
  end
  describe "setting the value of a data element" do
    before(:each) do 
      Security.stub!(:is_authenticated?).and_return true       
    end

    it "should render the json of the event data element" do
      EventDatum.should_receive(:create_or_update).with({}, session[:twitter_name]).and_return(mock_event_data)
      mock_event_data.should_receive(:save)
      mock_event_data.should_receive(:errors).and_return({})
      mock_event_data.should_receive(:to_json).and_return("JSONSTRING")

      post :set_data, :event_datum=>{}

      response.body.should == "JSONSTRING"
    end

    context "and there is a validation error" do
      it "should render an empty response, with a error http status and X-JSON header" do
        EventDatum.should_receive(:create_or_update).with({}, session[:twitter_name]).and_return(mock_event_data)
        mock_event_data.should_receive(:save)
        mock_event_data.should_receive(:errors).twice.and_return([["error1", "there is an error"]])
        request.should_receive(:xhr?).at_least(:once).and_return(true)        

        post :set_data, :event_datum=>{}

        response.headers.include?("X-JSON").should == true
        response.status.should == "444"
      end
    end
  end
end
