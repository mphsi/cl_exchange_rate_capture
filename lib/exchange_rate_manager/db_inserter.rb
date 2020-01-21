module ExchangeRateManager
  class DBInserter
    attr_reader :connection, :errors
    def initialize(connection = ExchangeRateManager::DBConnection.new)
      @connection = connection
      @errors     = []
    end

    def connection_works
      return true
    end

    def insert_exchange_rate(day:, value:)
      return true
    end
  end
end
