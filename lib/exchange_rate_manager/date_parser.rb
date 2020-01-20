require "date"

module ExchangeRateManager
  class DateParser
    def initialize
    end

    def parse_date(date)
      begin
        return Date.parse(date).strftime("%F")
      rescue
        return nil
      end
    end
  end
end
