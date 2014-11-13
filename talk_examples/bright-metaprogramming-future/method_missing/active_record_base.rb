class ActiveRecord::Base
  def method_missing(name, *args, &block)
    if name.ends_with('_changed?')
      attribute_changed?(name.gsub(/_changed?/, ''))
    end
  end
end
