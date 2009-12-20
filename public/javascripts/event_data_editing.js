$(document).ready(function() {	
	$("#edit_description_inline_link, #edit_description_link").click(function(){
		$("#edit_description_inline_link").hide();
		$("#edit_description_link").hide();
		$("#save_description_link").show();		
		$("#description_form").show();			
		$("#description_box").focus();
	});

	$("#edit_title_inline_link, #edit_title_link").click(function(){
		$("#edit_title_inline_link").hide();
		$("#edit_title_link").hide();
		$("#save_title_link").show();		
		$("#title_form").show();			
		$("#title_box").focus();
	});
	
	$("#edit_name_inline_link, #edit_name_link").click(function(){
		$("#edit_name_inline_link").hide();
		$("#edit_name_link").hide();
		$("#save_name_link").show();		
		$("#event_edit_form").show();			
		$("#event_box").focus();
	});
		
  	$('#save_description_link').click(function(){
		$('#description_form').submit();
	});
	
	$('#save_title_link').click(function(){
		$('#title_form').submit();
	});

	$('#save_name_link').click(function(){
		$('#event_edit_form').submit();
	});	
	
	$('#description_form').ajaxForm({
		dataType: 'json',
	    success: update_description		
	});
	
	$('#title_form').ajaxForm({
		dataType: 'json',
	    success: update_title		
	});	
});
function update_description(result) {	
	if (result.event.description == "")
		result.event.description = "Set a event description"
	$("#edit_description_inline_link").html(result.event.description);
	$("#description_box").val(result.event.description)
	$("#edit_description_inline_link").show();
	$("#edit_description_link").show();
	$("#save_description_link").hide();		
	$("#description_form").hide();
}
function update_title(result) {	
	if (result.event.title == "")
		result.event.title = "Set a event short name"
	$("#edit_title_inline_link").html(result.event.title);
	$("#title_box").val(result.event.title)
	$("#edit_title_inline_link").show();
	$("#edit_title_link").show();
	$("#save_title_link").hide();		
	$("#title_form").hide();
}