//interval to refresh in seconds
var tweet_refresh_intval = 15000;
var message_persister = new MessagePersister();
var tweet_puller = new TweetPuller(search_url, message_persister, process_callback);

$(document).ready(function() {		
		if (autoload)
			refresh_display();
		else
			setTimeout('refresh_display();', tweet_refresh_intval);
		
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

function refresh_display() {
	tweet_puller.get_tweets();
	setTimeout('refresh_display();', tweet_refresh_intval);	
}

function process_callback() {
	message_persister.save();
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




