// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function() {
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
});
