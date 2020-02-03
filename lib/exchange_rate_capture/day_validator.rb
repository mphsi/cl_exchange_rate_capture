require "date"

module ExchangeRateCapture
  class DayValidator
    def self.call(day)
      new(day).call
    end

    attr_reader :day
    def initialize(day)
      @day = day
    end

    def call
      begin
        return day == Date.parse(day).strftime("%F")
      rescue
        return false
      end
    end
  end
end
