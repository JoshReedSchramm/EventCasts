module GroupsHelper
  def pull_recent_tweets(tag,num)
    # assume the user passes the full tag

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
    req = Net::HTTP::Get.new("/search.json?" + "q=" + URI.escape("#{@search}") + "&" +"per_page=" + num.to_s)

    res = twitter.request(req)

    # Raise an exception unless Twitter
    # returned an OK result
    unless res.is_a? Net::HTTPOK
      html << res.body
    end

    html = ""
    html << "<b>JSON Respone:</b><br>"
    html << "<pre>"
    html << res.body
    html << "</pre>"
    html << "<br>"
    html << "<b>Parsed Response:</b><br>"

    result = JSON.parse(res.body)

    html << "<pre>"
    result["results"].each do |j|
      if j["text"] =~ /#{@match}/
      #if j["text"].casecmp(@match) # i would really love this work instead
        html << "<br/>"
        html << j.inspect
      end
    end
    html << "</pre>"

#    # Return the request body
#    return Hpricot(res.body)
#
#    Twitter::Search.new(@search).per_page(num).each do |r|
#      html << "<b>#{r.from_user}:</b>"
#      html << "&nbsp;"
#      html << "#{r.text}"
#      html << "<br/>"
#    end
#
#    Twitter::Request.post(Twitter::Base.new(Twitter::General.new()), "search", {:q => "#{@search}"}).each do |r|
#      html << "<b>#{r.from_user}:</b>"
#      html << "&nbsp;"
#      html << "#{r.text}"
#      html << "<br/>"
#    end
    html << "</pre>"
  end
end
