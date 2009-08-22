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
	$('#search_form').submit(function(){
		return false;
	});
});
