require_relative "exchange_rate_capture/db_connection"
require_relative "exchange_rate_capture/logger"
require_relative "exchange_rate_capture/day_validator"
require_relative "exchange_rate_capture/value_validator"
require_relative "exchange_rate_capture/persisted_record_validator"
require_relative "exchange_rate_capture/api_fetcher"
require_relative "exchange_rate_capture/db_inserter"
require_relative "exchange_rate_capture/capturist"
require "pry"

module ExchangeRateCapture
  class Error < StandardError; end
  # Your code goes here...
end
