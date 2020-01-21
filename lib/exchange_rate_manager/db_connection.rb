require "pg"

module ExchangeRateManager
  class Connection
    attr_reader :connection
    def new
      @connection = PG.connect(
        host: ENV['HOST'],
        dbname: ENV['DATBASE'],
        user: ENV['USERNAME'],
        password: ENV['PASSWORD']
      )
    end

    def exec(query_string = "")
      @connection.exec(query_string)
    end

    def close
      @connection.close
    end
  end
end
