require 'spec_helper'

describe Message do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Message.create!(@valid_attributes)
  end
  
  describe "when converting from json" do
    context "and multiple messages are passed in" do
      it "should create and return an array of message objects" do
        json = '[{"id":null,"original_id":9436657930,"from_user":"nicoshoney","origin_url":"http://www.twitter.com/","text":"@nickybyrneoiffic Nicky if you are tweeting or can see your twitter please say hello to all the Byrnettes who are listening to you!!!","profile_image_url":"http://a1.twimg.com/profile_images/701960264/8997302766a11149888758o_normal.jpg","created":"Sun, 21 Feb 2010 17:21:20 +0000","source":"&lt;a href=&quot;http://twitter.com/&quot;&gt;web&lt;/a&gt;"},{"id":null,"original_id":9436614460,"from_user":"adean3","origin_url":"http://www.twitter.com/","text":"RT @timgier: The smartest person in the world could well be behind a plow in China or India. - Hal Varian http://bit.ly/a0ae2K via @rww","profile_image_url":"http://a3.twimg.com/profile_images/684081239/vietnamtrain_normal.jpg","created":"Sun, 21 Feb 2010 17:20:05 +0000","source":"&lt;a href=&quot;http://twitter.com/&quot;&gt;web&lt;/a&gt;"}]'        
        object = JSON.parse(json)
        
        messages = Message.from_json(object)
        messages.length.should == 2
        
        messages.each do |message| 
          message.class.should == Message
        end        
      end
    end 
    context "and there is no json passed" do
      it "should return an empty array" do
        messages = Message.from_json(nil)
        messages.should == []
      end
    end   
    it "should convert the json fields to active record fields" do
      json = '[{"id":null,"original_id":1,"from_user":"eventcasts","origin_url":"http://www.twitter.com/","text":"An update message","profile_image_url":"http://a1.twimg.com/profile_images/701960264/8997302766a11149888758o_normal.jpg","created":"Sun, 21 Feb 2010 17:21:20 +0000","source":"&lt;a href=&quot;http://twitter.com/&quot;&gt;web&lt;/a&gt;"}]'
      object = JSON.parse(json)
      
      messages = Message.from_json(object)
      
      expected_date = DateTime.parse("Sun, 21 Feb 2010 17:21:20 +0000")

      messages[0].from_user.should == "eventcasts"
      messages[0].original_id.should == 1
      messages[0].origin_url.should == "http://www.twitter.com/"      
      messages[0].text.should == "An update message"      
      messages[0].profile_image_url.should == "http://a1.twimg.com/profile_images/701960264/8997302766a11149888758o_normal.jpg"            
      messages[0].created.should == expected_date
    end    
  end
end
