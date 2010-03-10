function MessagePuller(url, last_id) {
	var last_timestamp = null;
	this.url = url;

	this.get_messages = function(){
		if (last_id) {
			url = this.url + "&since_id="+last_id;
		}
		$.ajax({ 
			url: url, 
			dataType: "json",
			success: this.process_messages
		});		
	}
		
	this.process_messages = function(jsonData, textStatus) {
		if (jsonData && jsonData[0]) {
			last_id = jsonData[0].original_id;
			last_timestamp = jsonData[0].created;
		}
			
		var message_renderer = new MessageRenderer(jsonData);
		message_renderer.render();
		
		if (process_callback)
			process_callback();
	}
	
	this.last_timestamp = function(){
		return last_timestamp;
	}
}