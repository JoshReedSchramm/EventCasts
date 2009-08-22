class Search
  def Search.search(search)
    Group.search_by_name(search[:query])
  end
end
