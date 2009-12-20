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
		$("#addLink").hide();		
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
	
	$("#main_content form").submit(function(){
		var submitForm = false;
		$.ajax({
			url: "/user/verify_login",
			success: function(html) {
				if (html == "true") {
					submitForm = true;
				} else {
					$("#loginPopup").html(html);					
					$("#loginPopup").dialog({
						closeOnEscape: false,
						open: function(event, ui) { $(".ui-dialog-titlebar-close").hide(); }, //This removes the close button.						
						dialogClass: 'requiredDialog',
						draggable: false,
						modal: true,
						position: 'center',
						resizable: false,
						title: 'Please log in',
						width: 640
					});
					BindLoginPopupEvents();
				}
			}			
		});
		return submitForm;
	});
});

function BindSearchTermDefaults() {
	$('.active_search_term').watermark('#myevent');	
	$(".active_search_term").keyup(function(){
		if ($(this).val() != ""){
			$("#addLink").show();
		}
	});	
	$(".search_terms").focus(function(){
		$("#search_term_help").show();
	});
	$(".active_search_term").blur(function(){
		$("#search_term_help").hide();
			
		if ($(this).hasClass("watermark") && $(".search_terms").length > 1) {
			$(this).remove();
			$(".search_terms:last").addClass("active_search_term");			
			$("#addLink").show();
		}			
		
		$("#description_help").css("top", $("#event_description").offset().top-$("#main_content").offset().top-2);		
				
	});	
}
