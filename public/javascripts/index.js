/*$(document).ready(function() {
	if ($('#search_box').val() != "Find an event or group") {
		$('#search_box').css('color', 'black');
	}	
  	$('#search_button').click(function(){
		if ($('#search_box').val() == "Find an event or group") {
			$('#search_box').val("");
		}
		$('#search_form').submit();
	});
	$('#search_box').focus(function() {
		if ($('#search_box').val() == "Find an event or group") {
			$('#search_box').css('color', 'black');
			$('#search_box').val("");
		}	
	});
	$('#search_box').blur(function() {
		if ($('#search_box').val() == "") {
			$('#search_box').css('color', 'gray');		
			$('#search_box').val("Find an event or group");
		}	
	});
	$('#search_form').ajaxForm({
	    success: show_search_results
	});
	$("#add_event_link").click(function(){
		$("#cancel_add_event_link").show();
		$("#add_event_link").hide();
		$("#add_event_form").show();
		$("#add_event_box").focus();
	});
	$("#cancel_add_event_link").click(function(){
		$(".error_message").remove();
        
		$("#cancel_add_event_link").hide();
		$("#add_event_link").show();
		$("#add_event_form").hide();
	});
	$("#save_event_link").click(function(){
		$('#add_event_form').submit();
	});

	$('#add_event_form').ajaxForm({
	    success: update_sub_events,
		error: display_error
	});
});*/

function display_error(request, textStatus, errorThrown)
{
	errors = eval(request.getResponseHeader("X-JSON"));
	if (errors[0][0] == "name")
		display_error_on("event", errors[0][0], errors[0][1]);	
}

function update_sub_events(result, status) {
	$(".error_message").remove();		
	$("#user_events").html(result);
	$("#add_event_form").hide();	
	$('#add_event_link').show();						
	$('#cancel_add_event_link').hide();				
}

function display_error_on(model, field_name, error) {
	$(".error_message").remove();	
	$("input[name='"+model+"["+field_name+"]']").parent().after("<div class='error_message' id='error_"+field_name+"'>"+error+"</div>");
}

function show_search_results(response_text) {
	$("#description_text").hide();
	$("#search_results").html(response_text);	
	$("#search_results").show('slow');
}
