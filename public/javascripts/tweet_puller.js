function Message() {
	this.id = null;
	this.original_id = null;
	this.from_user = null;
	this.origin_url = null;
	this.text = null;
	this.profile_image_url = null;
	this.created = null;
	this.source = null;
}

function TweetPuller(url, message_persister, process_callback) {
	this.url = url;
	this.message_persister = message_persister;
	this.process_callback = process_callback;

	this.get_tweets = function(){
		$.ajax({ 
			url: url, 
			dataType: "jsonp",
			success: this.process_tweets
		});		
	}
	
	this.process_tweets = function(jsonData, textStatus) {
		var twitter_converter = new TwitterConverter(jsonData);
		var converted_messages = twitter_converter.convert();		
		
		if (message_persister) 
			message_persister.add(converted_messages);
			
		var message_renderer = new MessageRenderer(converted_messages);
		message_renderer.render();
		
		if (process_callback)
			process_callback();
	}
}

function TwitterConverter(messages) {
	this.messages = messages;
	
	this.convert = function() {
		var result = new Array();
		$.each(this.messages.results, function(count, message) {
			var new_message = new Message();
			new_message.original_id = message.id;
			new_message.from_user = message.from_user;
			new_message.origin_url = "http://www.twitter.com/";
			new_message.text = message.text;
			new_message.profile_image_url = message.profile_image_url;
			new_message.created = message.created_at;
			new_message.source = message.source;
			result.push(new_message);
		});
		return result;
	}
}

function MessageRenderer(messages) {
	this.messages = messages;
	
	this.render = function() {
		$("#loading_graphic").hide();
	    $.each(this.messages, this.render_message);
	}
	
	this.render_message = function(count, message) {
        var message_list_item = $("#messageTemplate").clone();
		message_list_item.attr("id", "message_"+message.id);
        $(".tweeter", message_list_item).html("<a href='" + message.origin_url + message.from_user + "' target='_blank'>@"+ message.from_user + "</a>");
        $(".tweet", message_list_item).html(message.text);
		$(".profile_image", message_list_item).attr("src", message.profile_image_url);
		$(".update_stamp", message_list_item).html(distanceOfTimeInWords(new Date(), new Date(message.created), false)+" ago from "+html_entity_decode(message.source));
        $("#messageTemplate").parent().append(message_list_item);		
	}
}