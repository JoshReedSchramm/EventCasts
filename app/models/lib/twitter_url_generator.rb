class TwitterURLGenerator 
  attr_accessor :search_terms
  attr_accessor :results_per_page
  attr_accessor :prior_tweet_id
  attr_accessor :file_type
  
  TWITTER_SEARCH_URL = "http://search.twitter.com/search"
  
  def initialize(search_terms)
    self.file_type = "json"
    self.search_terms = search_terms
  end
  
  def generate_url
    querystring = "#{TwitterURLGenerator::TWITTER_SEARCH_URL}."
    querystring << file_type
    querystring << "?ors="
    search_terms.each do |term|
      querystring << term.term
      querystring << "+"
    end
    querystring << "&rpp=" + results_per_page.to_s unless results_per_page.nil?
    querystring << "&since_id=" + prior_tweet_id.to_s unless prior_tweet_id.nil?    
    querystring
  end
end