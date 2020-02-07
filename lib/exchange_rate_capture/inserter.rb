module ExchangeRateCapture
  class Inserter
    def self.call(value, day)
      new(
        value,
        day,
        ExchangeRateCapture::DatabaseConnectionsGetter.call
      ).call
    end

    attr_reader :value, :day, :db_connections
    def initialize(value, day, db_connections)
      @value          = value
      @day            = day
      @db_connections = db_connections
    end

    def call
      return [] if db_connections.empty?

      begin
        return db_connections.map do |db_connection|
          DBInserter.call(value, day, db_connection)
        end
      rescue
        return []
      end
    end
  end
end
