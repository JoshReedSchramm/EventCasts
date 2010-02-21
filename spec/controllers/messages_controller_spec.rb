require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe MessagesController do
  def mock_message(stubs={})
    @mock_message ||= mock(Message, stubs)
  end
  
  describe "when persisting a new message" do
    it "should convert the message from json and save" do
      params = {:messages => "{\"message\":[{\"name\":\"test\", \"original_id\":\"1\"},{\"name\":\"test\", \"original_id\":\"2\"}]};" }
      
      messages = [mock_message, mock_message]
      Message.should_receive(:from_json).with(params[:messages]).and_return(messages)      
      mock_message.should_receive(:save).twice.and_return true
      
      post :persist, params
      response.response_code.should == 200      
    end
    
    context "and there is no json payload" do
      it "should return a json error" do
        params = {:messages=>"{\"message\":[]};"}
        
        messages = []
        Message.should_receive(:from_json).with(params[:messages]).and_return(messages)      
        mock_message.should_not_receive(:save)
      
        post :persist, params
        response.response_code.should == 200      
      end
    end
  end
end
