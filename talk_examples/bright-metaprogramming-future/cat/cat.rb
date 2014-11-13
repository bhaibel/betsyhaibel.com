class Cat
  attr_accessor :photo

  %w(url name path).each do |method|
    define_method "photo_#{method}" do
      photo.send(method)
    end
  end
end
