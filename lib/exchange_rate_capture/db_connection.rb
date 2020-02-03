require "pg"

module ExchangeRateCapture
  class DBConnection
    attr_reader :connection
    def initialize()
      @connection = PG.connect(
        host: ENV['HOST'],
        dbname: ENV['DATBASE'],
        user: ENV['USERNAME'],
        password: ENV['PASSWORD']
      )
    end

    def exec(query_string = "")
      begin
        @connection.exec(query_string)
      rescue
        return nil
      end
    end

    def close
      @connection.close
    end
  end
end
