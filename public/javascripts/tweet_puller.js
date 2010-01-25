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
		var tmp;
	    var cssObj = {'display' : 'visible'};
		var tweets = jsonData.results;
		var first = true; //not sure what this does quite yet, copied from old code
		
		$("#loading_graphic").hide();
		
	    $.each(tweets, function(count, tweet){
	        tmp = $("#tweetTemplate").clone()
			tmp.attr("id", "tweet_"+tweet.id);
	        $(".tweeter", tmp).html("<a href='http://twitter.com/" + tweet.from_user + "' target='_blank'>@"+ tweet.from_user + "</a>");
	        $(".tweet", tmp).html(tweet.text);
			$(".profile_image", tmp).attr("src", tweet.profile_image_url);
			$(".update_stamp", tmp).html(distanceOfTimeInWords(new Date(), new Date(tweet.created_at), false)+" ago from "+html_entity_decode(tweet.source));
	        if (first) {
	            $("#tweetTemplate").parent().append(tmp);
	        } else {
	            $("#tweetTemplate").parent().prepend(tmp);
	        }
	    });	    
	}
}