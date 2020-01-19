# Provides an interface for working with exchange rates
module ExchangeRateManager
  class Manager
    def initialize
    end

    def fetch_exchange_rate(day:, fetcher: nil)
      value = fetcher.fetch_exchange_rate(day: day)

      return {
        "requested_day" => day,
        "exchange_rate_found" => (true.nil? ? false : true),
        "exchange_rate_value" => (value.nil? ? nil : value.to_f),
        "errors" => fetcher.errors
      }
    end

    def insert_exchange_rate(day:, value:, inserter: nil)
      inserted = inserter.insert_exchange_rate(day: day, value: value)

      return {
        "requested_day" => day,
        "exchange_rate_value" => value.to_f,
        "exchange_rate_inserted" => inserted,
        "errors" => inserter.errors
      }
    end
  end
end
