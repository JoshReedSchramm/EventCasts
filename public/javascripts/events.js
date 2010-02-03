//interval to refresh in seconds
var tweet_refresh_intval = 15

$(document).ready(function() {
        $("#save_vip_link").click(function(){
                $('#add_vip_form').submit();
        });

       $('#add_vip_form').ajaxForm({
            success: update_vip
        });
        
        $('#add_vip_link').click(function(){
                $("#add_vip").show();
                $('#cancel_add_vip_link').show();
                $('#add_vip_link').hide();
                $('#add_vip_box').focus();
                $('#add_vip_box').val('');
        });

        $('#cancel_add_vip_link').click(function(){
                $("#add_vip").hide();
                $('#add_vip_link').show();
                $('#cancel_add_vip_link').hide();
        });
});

function update_vip(result) {
	if (result.indexOf("Error: ")>-1) {
 		display_error_on('add_vip_box', result.substr(result.indexOf("Error: ")+7));
	} else {
		$(".error_message").remove();
		$("#vip_content").html(result);		
		$("#add_vip").hide();
		$('#add_vip_link').show();
		$('#cancel_add_vip_link').hide();
	}
}




