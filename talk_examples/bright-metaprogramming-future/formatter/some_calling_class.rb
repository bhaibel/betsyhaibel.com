class SomeCallingClass
  def available_patterns(options)
    results = Searcher.search(garment, user_type, options)
    Formatter.send("format_#{garment}_results_for_#{user_type}", results)
  end
end
