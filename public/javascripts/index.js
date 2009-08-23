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
});
function show_search_results(response_text) {
	$("#description_text").hide();
	$("#search_results").html(response_text);	
	$("#search_results").show('slow');
}
