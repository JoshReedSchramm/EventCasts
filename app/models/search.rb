class Search
  def Search.search(search)
    @results = []
    @results << Group.search_by_name(search[:query])
    @results
  end
end
