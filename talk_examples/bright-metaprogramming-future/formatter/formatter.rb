class Formatter
  def self.format_results(garment, user_type, results)
    send("format_#{garment}_results_for_#{user_type}", results)
  end

  def self.format_sweater_results_for_admin(results)
    CSV.generate do |csv|
      results.each do |result|
        arr = [:id, :name, :yarn_name, :yardage, :sleeve_length, :currently_promoting?].map do |attribute|
          result.send(attribute)
        end
        csv << arr
      end
    end
  end

  def self.format_sweater_results_for_user(results)
    results.map do |x|
      [:name, :yarn_name, :yardage, :sleeve_length].map { |attribute| result.send(attribute) } 
    end.to_json
  end

  def self.format_hat_results_for_user(results)
    results.map do |x|
      [:name, :yarn_name, :earflaps?].map { |attribute| result.send(attribute) } 
    end.to_json
  end
end
