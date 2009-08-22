class Search
  def Search.search(search)
    @results = []

    name_search_result = Search.search_by_name search
    @results << name_search_result
    @results << Search.search_by_title(search)
    @results << Search.search_by_description(search)
    @results
  end

  def Search.search_by_name search
    result = SearchResult.new()
    group_result = Group.search_by_name(search[:query])
    result.group = group_result
    result
  end

  def Search.search_by_description search_term
    groups = Group.find_by_description search_term
    search_results = convert_groups_to_search_results groups
  end

  def Search.search_by_title search_term
    groups = Group.find_by_title search_term
    search_results = convert_groups_to_search_results groups
  end

  def Search.convert_groups_to_search_results groups
    results = []

    groups.each do |group|
      result = SearchResult.new
      result.group = group
      results << result
    end

    results
  end
end