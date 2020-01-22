module ExchangeRateManager
  class DBInserter
    attr_reader :connection, :errors
    def initialize(connection = ExchangeRateManager::DBConnection.new)
      @connection = connection
      @errors     = []
      connection_works?
    end

    def connection_works?
      if connection_test_output == connection_test_expected_output
        @errors -= [db_connection_error]
      else
        @errors += [db_connection_error]
      end
      @errors.include?(db_connection_error) == false
    end

    def insert_exchange_rate(day:, value:)
      begin
        @connection.exec("INSERT INTO tipo_cambios ...")
      rescue
        return nil
      end
    end

    private

    def db_connection_error
      "ExchangeRateManager::DBInserter : invalid connection"
    end

    def connection_test_output
      begin
        @connection.exec("select 5 + 5") # parse result
      rescue
        nil
      end
    end

    def connection_test_expected_output
      10
    end
  end
end
