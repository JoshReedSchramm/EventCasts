$(document).ready(function() {	
  	$('#save_description').click(function(){
		$('#description_form').submit();
	});
	/*$('#description_form').ajaxForm({
	    success: update_description		
	});*/
});
function update_description(response_text) {	
	alert(response_text);
}
