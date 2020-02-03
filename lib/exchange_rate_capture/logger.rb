module ExchangeRateCapture
  class Logger
    attr_reader :db_connection
    def initialize(db_connection: nil)
      @db_connection = db_connection
    end

    def log(event:, data: nil)
      puts event
    end
  end
end
