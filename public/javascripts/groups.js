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
});

function update_tweet_results(tweets, first) {
    var tmp;
    var cssObj = {'display' : 'visible'};
    if(tweets.length > 0) {
        $("#sinceTweetId").val(tweets[0].id)
    }
    $.each(tweets, function(count, tweet){
        tmp = $("#tweetTemplate").clone()
        $("#tweeter", tmp).html(tweet.from_user);
        $("#tweet", tmp).html(tweet.text);
        if (first) {
            $("#tweetTemplate").parent().append(tmp);
        } else {
            $("#tweetTemplate").parent().prepend(tmp);
        }
    });
}
