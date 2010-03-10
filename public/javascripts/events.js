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
		
        $("#save_vip_link").click(function(){
                $('#add_vip_form').submit();
        });

       $('#add_vip_form').ajaxForm({
            success: update_vip
        });
        
        $('#add_vip_link').click(function(){
                $("#add_vip").show();
                $('#cancel_add_vip_link').show();
                $('#add_vip_link').hide();
                $('#add_vip_box').focus();
                $('#add_vip_box').val('');
        });

        $('#cancel_add_vip_link').click(function(){
                $("#add_vip").hide();
                $('#add_vip_link').show();
                $('#cancel_add_vip_link').hide();
        });
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


function update_vip(result) {
	if (result.indexOf("Error: ")>-1) {
 		display_error_on('add_vip_box', result.substr(result.indexOf("Error: ")+7));
	} else {
		$(".error_message").remove();
		$("#vip_content").html(result);		
		$("#add_vip").hide();
		$('#add_vip_link').show();
		$('#cancel_add_vip_link').hide();
	}
}




