class Searcher
  def search(garment, user_type, options)
    results = garment.camelcase.constantize.visible_to(user_type).where(options)
  end
end
