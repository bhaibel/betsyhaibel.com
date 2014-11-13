class ActiveRecord::Base
  def method_missing(name, *args, &block)
    if name.ends_with('_changed?')
      self.class.define_method name do
        attribute_changed?(name.gsub(/_changed?/, ''))
      end
      send name
    else
      super
    end
  end

  def respond_to_missing?(name, include_private = false)
    name.ends_with('_changed?') || super
  end
end
