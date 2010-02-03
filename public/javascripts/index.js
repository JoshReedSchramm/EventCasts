function show_search_results(response_text) {
	$("#description_text").hide();
	$("#search_results").html(response_text);	
	$("#search_results").show('slow');
}
