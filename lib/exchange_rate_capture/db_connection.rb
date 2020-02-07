require "pg"

module ExchangeRateCapture
  class DBConnection
    attr_reader :connection
    def initialize(credentials = {})
      @connection = PG.connect(
        host: credentials["host"],
        dbname: credentials["dbname"],
        user: credentials["user"],
        password: credentials["password"]
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
