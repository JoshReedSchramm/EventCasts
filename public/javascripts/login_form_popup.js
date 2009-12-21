function BindLoginPopupEvents() {
	$("#forgot_password").click(function(){
		$("#forgot_password_container").show();
	});
	
	$("#prompt_create_account").click(function(){
		$("#ui-dialog-title-loginPopup").text("Create an Account");
		$("#login_form_popup").hide();		
		$("#create_account_link").hide();
		$("#create_account_popup").fadeIn();
		$("#return_to_login_link").show();
	});
	
	$(".return_to_login").click(function(){
		$("#ui-dialog-title-loginPopup").text("Please log in");
		$("#password_reset_content").hide();		
		$("#create_account_popup").hide();
		$("#forgot_password_container").hide();		
		$(".validation_error").remove();		
		$("#login_form_popup").fadeIn();		
		$("#create_account_link").show();
		$("#return_to_login_link").hide();					
	});
	
	$("#login_form_popup form").ajaxForm({
		success: function(response){
			alert('logged in');
		},
		error: function(xhr, status, error) {
			RenderValidationErrors(xhr, DisplayErrorAsFlash);
		}
	});		
	
	$("#create_account_popup form").ajaxForm({
		success: function(response){
			alert('account created and logged in.');
		},
		error: function(xhr, status, error) {
			RenderValidationErrors(xhr, HandleErrorInline);
		}		
	});
}

function RenderValidationErrors(xhr, errorHandler) {
	$(".validation_error").remove();
	var json = JSON.parse(xhr.getResponseHeader("X-JSON"));
	for (msgClass in json) {
		msgsOfClass = typeof( json[msgClass] ) == 'string' ? new Array(json[msgClass]) : json[msgClass];
		for (var i = 0; i < msgsOfClass.length; i+=2) {
			var field = msgsOfClass[i];
			var error = msgsOfClass[i+1];
			errorHandler(field, error);
		}
	}	
}

function HandleErrorInline(field, error) {
	var row = $("input[id*="+field+"]").parent();
	row.append("<span class='validation_error'>"+error+"</span>");
}

function DisplayErrorAsFlash(field, error) {
	alert(error);
}