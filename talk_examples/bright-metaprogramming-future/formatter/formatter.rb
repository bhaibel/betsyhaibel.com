class Formatter
  def self.format_results(garment, user_type, results)
    new(garment, user_type, results).format
  end

  attr_reader :garment, :user_type, :results
  def initialize(garment, user_type, results)
    @garment = garment
    @user_type = user_type
    @results = results
  end

  def format
    send("format_#{garment}_results_for_#{user_type}")
  end

  def format_sweater_results_for_admin
    CSV.generate do |csv|
      results.each do |result|
        arr = Sweater.attributes_for_formatter(admin: true).map do |attribute|
          result.send(attribute)
        end
        csv << arr
      end
    end
  end

  def format_sweater_results_for_user
    results.map do |x|
      Sweater.attributes_for_formatter(admin: false).map { |attribute| result.send(attribute) } 
    end.to_json
  end

  def format_hat_results_for_user
    results.map do |x|
      [:name, :yarn_name, :earflaps?].map { |attribute| result.send(attribute) } 
    end.to_json
  end
end
