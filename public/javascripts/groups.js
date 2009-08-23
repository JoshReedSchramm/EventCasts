//interval to refresh in seconds
var tweet_refresh_intval = 30

$(document).ready(function() {
        $.getJSON("?format=json", function(res){
            update_tweet_results(res,true);
        });

        setInterval(function() {
            //get the last tweet vlaue
            var since = $("#sinceTweetId").val();
            var path = "?format=json";
            if(parseInt(since,10) > 0) {
                path += "&since_id=" + since;
            }

            $.getJSON(path, function(res) {
                update_tweet_results(res);
            });
        }, tweet_refresh_intval * 1000);

		$("#save_subgroup_link").click(function(){
			$('#add_sub_group_form').submit();
		});

		$('#add_sub_group_form').ajaxForm({
		    success: update_sub_groups		
		});
		
		$('#add_subgroup_link').click(function(){
			$("#add_sub_group").show();
			$('#cancel_add_subgroup_link').show();
			$('#add_subgroup_link').hide();						
		});
		
		$('#cancel_add_subgroup_link').click(function(){
			$("#add_sub_group").hide();	
			$('#add_subgroup_link').show();						
			$('#cancel_add_subgroup_link').hide();					
		});
});

function update_sub_groups(result) {
	if (result.indexOf("Error: ")>-1) {	
 		display_error_on('add_subgroup_box', result.substr(result.indexOf("Error: ")+7));
	} else {
		$(".error_message").remove();		
		$("#subgroup_list").html(result);
		$("#add_sub_group").hide();	
		$('#add_subgroup_link').show();						
		$('#cancel_add_subgroup_link').hide();				
	}
}

function display_error_on(fieldId, error) {
	$(".error_message").remove();
	
	$("#"+fieldId).parent().after("<div class='error_message' id='error_"+fieldId+"'>"+error+"</div>");
	var parent_pos = $("#"+fieldId).position();
}
function update_tweet_results(tweets, first) {
    var tmp;
    var cssObj = {'display' : 'visible'};
    if(tweets.length > 0) {
        $("#sinceTweetId").val(tweets[0].id)
    }
    $.each(tweets, function(count, tweet){
        tmp = $("#tweetTemplate").clone()
		tmp.attr("id", "tweet_"+tweet.id);
        $(".tweeter", tmp).html(tweet.from_user);
        $(".tweet", tmp).html(tweet.text);
		$(".profile_image", tmp).attr("src", tweet.profile_image_url);
		$(".update_stamp", tmp).html(distanceOfTimeInWords(new Date(), new Date(tweet.created_at), false)+" ago from "+html_entity_decode(tweet.source));
        if (first) {
            $("#tweetTemplate").parent().append(tmp);
        } else {
            $("#tweetTemplate").parent().prepend(tmp);
        }
    });
}

function html_entity_decode(str) {
  var ta=document.createElement("textarea");
  ta.innerHTML=str.replace(/</g,"&lt;").replace(/>/g,"&gt;");
  return ta.value;
}

function distanceOfTimeInWords(fromTime, toTime, includeSeconds) {
  var fromSeconds = fromTime.getTime();
  var toSeconds = toTime.getTime();
  var distanceInSeconds = Math.round(Math.abs(fromSeconds - toSeconds) / 1000)
  var distanceInMinutes = Math.round(distanceInSeconds / 60)
  if (distanceInMinutes <= 1) {
    if (!includeSeconds)
      return (distanceInMinutes == 0) ? 'less than a minute' : '1 minute'
    if (distanceInSeconds < 5)
      return 'less than 5 seconds'
    if (distanceInSeconds < 10)
      return 'less than 10 seconds'
    if (distanceInSeconds < 20)
      return 'less than 20 seconds'
    if (distanceInSeconds < 40)
      return 'half a minute'
    if (distanceInSeconds < 60)
      return 'less than a minute'
    return '1 minute'
  }
  if (distanceInMinutes < 45)
    return distanceInMinutes + ' minutes'
  if (distanceInMinutes < 90)
    return "about 1 hour" 
  if (distanceInMinutes < 1440)
    return "about " + (Math.round(distanceInMinutes / 60)) + ' hours'
  if (distanceInMinutes < 2880)
    return "1 day" 
  if (distanceInMinutes < 43200)
    return (Math.round(distanceInMinutes / 1440)) + ' days'
  if (distanceInMinutes < 86400)
    return "about 1 month" 
  if (distanceInMinutes < 525600)
    return (Math.round(distanceInMinutes / 43200)) + ' months'
  if (distanceInMinutes < 1051200)
    return "about 1 year" 
  return "over " + (Math.round(distanceInMinutes / 525600)) + ' years'
}
