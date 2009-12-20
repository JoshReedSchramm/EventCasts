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
		$("#login_form_popup").fadeIn();		
		$("#create_account_link").show();
		$("#return_to_login_link").hide();					
	});
	
	$("#login_form_popup form").ajaxForm({
		success: function(response){
			alert('logged in');
		},
		error: function(xhr, status, error) {
			alert('got an error');
		}
	});		
}