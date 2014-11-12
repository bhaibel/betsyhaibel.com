class Sweater
  def self.attributes_for_formatter(options)
    admin = options.fetch(:admin, false)
    result = [:name, :yarn_name, :yardage, :sleeve_length]
    result << [:id, :currently_promoting?] if admin
    result
  end
end