class SomeCallingClass
  def available_patterns(options)
    results = Searcher.search(garment, user_type, options)
    Formatter.format_results(garment, user_type, results)
  end
end
