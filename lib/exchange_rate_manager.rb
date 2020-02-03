require "exchange_rate_manager/version"
require "exchange_rate_manager/date_parser"
require "exchange_rate_manager/float_parser"
require "exchange_rate_manager/sie_api_fetcher"
require "exchange_rate_manager/db_connection"
require "exchange_rate_manager/db_inserter"
require "exchange_rate_manager/manager"
require "exchange_rate_capture/db_connection"
require "exchange_rate_capture/logger"
require "exchange_rate_capture/day_validator"
require "exchange_rate_capture/value_validator"
require "exchange_rate_capture/persisted_record_validator"
require "exchange_rate_capture/api_fetcher"
require "exchange_rate_capture/db_inserter"
require "exchange_rate_capture/capturist"
require "pry"

module ExchangeRateManager
  class Error < StandardError; end
  # Your code goes here...
end
