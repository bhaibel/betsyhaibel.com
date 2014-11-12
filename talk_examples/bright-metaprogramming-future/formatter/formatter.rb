class Formatter
  def self.format_results(user_type, results)
    const_get("#{user_type}Formatter", false).new(results).format
  end

  class AbstractFormatter
    attr_reader :results
    def initialize(results)
      @results = results
    end
  end

  class UserFormatter < AbstractFormatter
    def format
      results.map(&:to_formatter_data).to_json
    end
  end

  class AdminFormatter < AbstractFormatter
    def format
      CSV.generate do |csv|
        results.each do |result|
          csv << result.to_formatter_data(admin: true)
        end
      end
    end
  end
end
