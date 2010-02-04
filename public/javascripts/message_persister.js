function MessagePersister() {
	this.messages = new Array();
	
	this.add = function(data){
		this.messages.push(data);
	}
	
	this.save = function() {
		alert(this.messages);
	}
}