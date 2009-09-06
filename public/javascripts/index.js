$(document).ready(function() {
	if ($('#search_box').val() != "Search for conversations") {
		$('#search_box').css('color', 'black');
	}	
  	$('#search_button').click(function(){
		if ($('#search_box').val() == "Search for conversations") {
			$('#search_box').val("");
		}
		$('#search_form').submit();
	});
	$('#search_box').focus(function() {
		if ($('#search_box').val() == "Search for conversations") {
			$('#search_box').css('color', 'black');
			$('#search_box').val("");
		}	
	});
	$('#search_box').blur(function() {
		if ($('#search_box').val() == "") {
			$('#search_box').css('color', 'gray');		
			$('#search_box').val("Search for conversations");
		}	
	});
	$('#search_form').ajaxForm({
	    success: show_search_results
	});
	$("#add_group_link").click(function(){
		$("#cancel_add_group_link").show();
		$("#add_group_link").hide();
		$("#add_group_form").show();
		$("#add_group_box").focus();
	});
	$("#cancel_add_group_link").click(function(){
		$(".error_message").remove();
        
		$("#cancel_add_group_link").hide();
		$("#add_group_link").show();
		$("#add_group_form").hide();
	});
	$("#save_group_link").click(function(){
		$('#add_group_form').submit();
	});

	$('#add_group_form').ajaxForm({
	    success: update_sub_groups,
		error: display_error
	});
});

function display_error(request, textStatus, errorThrown)
{
	errors = eval(request.getResponseHeader("X-JSON"));
	if (errors[0][0] == "name")
		display_error_on("group", errors[0][0], errors[0][1]);	
}

function update_sub_groups(result, status) {
	$(".error_message").remove();		
	$("#user_groups").html(result);
	$("#add_group_form").hide();	
	$('#add_group_link').show();						
	$('#cancel_add_group_link').hide();				
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
