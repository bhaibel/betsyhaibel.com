class Cat
  attr_accessor :photo

  def photo_url
    photo.url
  end

  def photo_name
    photo.name
  end

  def photo_path
    photo.path
  end
end
