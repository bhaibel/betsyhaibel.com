module AttachmentManager
  def define_attachment(name)
    attr_accessor name

    %w(url name path).each do |method|
      define_method "#{name}_#{method}" do
        send(name).send(method)
      end
    end
  end
end
