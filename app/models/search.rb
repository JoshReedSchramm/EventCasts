class Search
  def Search.search(search)
    @results = []
    @result = SearchResult.new()
    @group_result = Group.search_by_name(search[:query])    
    @result.group = @group_result
    @results << @result
    @results
  end
end
