//interval to refresh in seconds
var tweet_refresh_intval = 15000;
var message_persister = new MessagePersister();
var tweet_puller = new TweetPuller(twitter_search_url, message_persister, process_callback, twitter_last_message_id);
//var message_puller = new MessagePuller('/messages/get_messages', null, ec_last_message_id);

$(document).ready(function() {		
	if (autoload)
		refresh_display(false);
	else
		setTimeout('refresh_display(false);', tweet_refresh_intval);
});

function refresh_display(check_ec_first) {
	var load_from_twitter = !check_ec_first;
//	if (check_ec_first) {
//		message_puller.get_messages();
//		load_from_twitter = true;
//	}
//	if (load_from_twitter) {
		tweet_puller.get_tweets();
//	}
	setTimeout('refresh_display(false);', tweet_refresh_intval);	
}

function process_callback() {
	message_persister.save(
		function(){
			if (message_persister.latest_id()) {
				ec_last_message_id = message_persister.latest_id();
			}
		}
	);
}




