class Search
  def Search.search(search)
    search_term = search[:query]#.gsub(/[\@\#]/, '')
    groups = Array.new

    results_by_name = Search.search_by_name search_term
    groups << results_by_name unless results_by_name.nil?
    groups.concat Search.search_by_title(search_term)
    groups.concat Search.search_by_description(search_term)
    @results = Search.convert_groups_to_search_results(groups.uniq)
  end

  def Search.search_by_name search_term
    Group.search_by_name(search_term)
  end

  def Search.search_by_description search_term
    Group.find_by_description search_term
  end

  def Search.search_by_title search_term
    Group.find_by_title search_term
  end

  def Search.convert_groups_to_search_results groups
    return [] if groups.nil?

    results = []

    groups.each do |group|
      result = SearchResult.new
      result.group = group
      results << result
    end

    results
  end
end