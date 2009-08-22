$(document).ready(function() {	
	$("#group_description").click(function(){
		$("#group_description").hide();
		$("#description_form").show();				
	});
	
  	$('#save_description').click(function(){
		$('#description_form').submit();
	});
	$('#description_form').ajaxForm({
		dataType: 'json',
	    success: update_description		
	});
});
function update_description(result) {	
	if (result.group_datum.description == "")
		result.group_datum.description = "Set a group description"
	$("#group_description").html(result.group_datum.description);
	$("#description_box").val(result.group_datum.description)
	$("#group_description").show();	
	$("#description_form").hide();
}
