require "exchange_rate_manager/version"
require "exchange_rate_manager/date_parser"
require "exchange_rate_manager/sie_api_fetcher"
require "exchange_rate_manager/db_connection"
require "exchange_rate_manager/db_inserter"
require "exchange_rate_manager/manager"
require "pry"

module ExchangeRateManager
  class Error < StandardError; end
  # Your code goes here...
end
