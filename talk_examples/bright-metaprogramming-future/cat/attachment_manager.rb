module AttachmentManager
  def define_attachment(name)
    instance_methods = Module.new do
      attr_accessor name

      %w(url name path).each do |method|
        define_method "#{name}_#{method}" do
          send(name).send(method)
        end
      end
    end
    const_set("#{name.capitalize}Methods", instance_methods)
    include const_get("#{name.capitalize}Methods", false)
  end
end
