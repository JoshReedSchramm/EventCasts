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
});