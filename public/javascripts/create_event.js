$(document).ready(function(){
	$('#event_name').watermark('Event Name');
	$('#event_description').watermark('Description');
	BindSearchTermDefaults();
	$("#add_search_term").click(function(){
		var index = ($(".search_terms").length);
		var newTerm = $(".active_search_term").clone();
		$(".active_search_term").removeClass("active_search_term");
		
		newTerm.attr("id", "search_terms_"+index);
		newTerm.attr("name", "post[search_terms]["+index+"]");
		newTerm.addClass("active_search_term");
		newTerm.val("");		
		
		$("#search_terms").append(newTerm);
		BindSearchTermDefaults();		
		newTerm.focus();
		$("#addLink").fadeOut();		
	});
	$("#event_name").focus(function(){
		$("#event_name_help").show();
	});
	$("#event_name").blur(function(){
		$("#event_name_help").hide();
	});
	$("#event_description").focus(function(){
		$("#description_help").show();
	});
	$("#event_description").blur(function(){
		$("#description_help").hide();		
	});
});

function BindSearchTermDefaults() {
	$('.active_search_term').watermark('#myevent');	
	$(".active_search_term").keyup(function(){
		if ($(this).val() != ""){
			$("#addLink").fadeIn();
		}
	});	
	$(".search_terms").focus(function(){
		$("#search_term_help").show();
	});
	$(".active_search_term").blur(function(){
		$("#search_term_help").hide();
		
		if ($("#addLink").is(":visible")) {
			$("#add_search_term").focus(); 
		}
	});	
}
