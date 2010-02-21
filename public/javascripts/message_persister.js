function MessagePersister() {
	this.messages = new Array();
	
	this.add = function(data){
		
		this.messages = this.messages.concat(data);
	}
	
	this.save = function() {		
		var encoded = $.toJSON(this.messages);
		$('#json').text(encoded);
	}
}