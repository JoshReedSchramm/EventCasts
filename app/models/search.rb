class Search
  def Search.search(search)
    search_term = search[:query].gsub(/[\@\#]/, '')
    events = Array.new

    results_by_name = Search.search_by_name search_term
    events << results_by_name unless results_by_name.nil?
    events.concat Search.search_by_title(search_term)
    events.concat Search.search_by_description(search_term)
    @results = Search.convert_events_to_search_results(events.uniq)
  end

  def Search.search_by_name search_term
    Event.search_by_name(search_term)
  end

  def Search.search_by_description search_term
    Event.find_by_description search_term
  end

  def Search.search_by_title search_term
    Event.find_by_title search_term
  end

  def Search.convert_events_to_search_results events
    return [] if events.nil?

    results = []

    events.each do |event|
      result = SearchResult.new
      result.event = event
      results << result
    end

    results
  end
end