require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe TwitterURLGenerator do
  before(:each) do
  end
  
  context "when creating a url generator" do
    it "should initalize the search terms" do
      url_generator = TwitterURLGenerator.new(['term1', 'term2'])
      url_generator.search_terms.should == ['term1', 'term2']
    end
    it "should initialize the file type to default to json" do
      url_generator = TwitterURLGenerator.new([])
      url_generator.file_type.should == "json"
    end
  end
  
  context "when generating a url" do
     before(:each) do
        @search_term = SearchTerm.new({:term=>'eventcasts'})
        @url_generator = TwitterURLGenerator.new([@search_term])
      end    
    it "should begin with the twitter search url and file type" do
      url = @url_generator.generate_url
      result = url.starts_with? "#{TwitterURLGenerator::TWITTER_SEARCH_URL}.json"
      result.should == true
    end
    context "and there is one search term" do
      it "should return a single parameter to the ors collection" do
        url = @url_generator.generate_url
        result = url.ends_with? "ors=eventcasts+"
        result.should == true
      end
    end    
    context "and there are multiple search terms" do
      it "should return all search terms seperated with a plus" do
        search_term2 = SearchTerm.new({:term=>'test'})        
        @url_generator.search_terms = [@search_term, search_term2]
        url = @url_generator.generate_url
        result = url.ends_with? "ors=eventcasts+test+"
        result.should == true        
      end
    end
    context "and a value is provided for results per page" do
      it "should include the rpp querystring parameter with the results per page value" do
        @url_generator.results_per_page=50
        url = @url_generator.generate_url      
        result = url.include? "&rpp=50"
        result.should == true                
      end
    end
    context "and a value is provided for prior tweet id" do
      it "should include the since_id querystring parameter with the prior tweet id value" do
        @url_generator.prior_tweet_id=101
        url = @url_generator.generate_url      
        result = url.include? "&since_id=101"
        result.should == true                
      end
    end
  end
end