function MessagePersister() {
	this.messages = new Array();
	var latest_id = null;
	
	this.add = function(data){		
		this.messages = this.messages.concat(data);
	}
	
	this.save = function(callback) {
		var encoded_messages = $.toJSON(this.messages);
		this.messages = new Array();
		$.ajax({
			type: 'POST',
			url: '/messages/persist', 
			data: encoded_messages,
			contentType: "application/json; charset=utf-8",
			success: function(data){
				latest_id = data;
				callback();
			},
			error: function(xhr, errorText, e) {
			}
		});
	}
	
	this.latest_id = function() {
		return latest_id;
	}
}