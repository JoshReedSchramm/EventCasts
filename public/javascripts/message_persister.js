function MessagePersister() {
	this.messages = new Array();
	
	this.add = function(data){		
		this.messages = this.messages.concat(data);
	}
	
	this.save = function() {
		var encoded_messages = $.toJSON(this.messages);
		this.messages = new Array();
		$.ajax({
			type: 'POST',
			url: '/messages/persist', 
			data: encoded_messages,
			contentType: "application/json; charset=utf-8",
			success: function(data){
			},
			error: function(xhr, errorText, e) {
			}
		});
	}
}