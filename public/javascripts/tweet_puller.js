function TweetPuller(url) {
	this.url = url;
	
	this.get_tweets = function(){
		$.ajax({ 
			url: this.url, 
			dataType: "jsonp",
			success: TweetPuller.process_tweets
		});		
	}
	
	TweetPuller.process_tweets = function(jsonData, textStatus) {
//		alert('process');
//		alert(jsonData);
	}
}