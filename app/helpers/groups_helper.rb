module GroupsHelper
  def pull_recent_tweets(tag,num = nil,since = nil)
    # assume the user passes the full tag

    html = ""
    @terms = tag.split('/')
    @search = ""
    @match = ""
    @terms.each do |t|
      @search << "+##{t}"
      @match << "##{t} "
    end
    #remove trailing space
    @match.chop!

    logger.debug("Searching for #{@search}")
    logger.debug("Matching on #{@match}")


    twitter = Net::HTTP.start('search.twitter.com')
    # Set the form data with options
    command = "/search.json?" + "q=" + URI.escape("#{@search}")
    command << "&" + "per_page=" + num.to_s if !num.nil?
    command << "&" + "since_id=" + since.to_s if !since.nil?

    req = Net::HTTP::Get.new(command)

    res = twitter.request(req)

    # Raise an exception unless Twitter
    # returned an OK result
    unless res.is_a? Net::HTTPOK
      html << res.body
    end

    result = JSON.parse(res.body)

    json_result = Array.new()
    result["results"].each do |j|
      if j["text"] =~ /#{@match}/
        json_result.push(j)
      end
    end

    json_result.to_json
  end
end
