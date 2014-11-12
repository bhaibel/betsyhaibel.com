class Sweater
  def to_formatter_data(options)
    admin = options.fetch(:admin, false)
    result = [name, yarn_name, yardage, sleeve_length]
    result << [id, currently_promoting?] if admin
    result
  end
end