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
          append_connection_details(
            DBInserter.call(value, day, db_connection),
            db_connection
          )
        end
      rescue
        return []
      end
    end

    private

    def append_connection_details(record, connection)
      if record["id"].nil?
        record["_status"] = "not inserted"
      else
        record["_status"] = "inserted"
      end
      record["_database_name"] = connection.database_name
      record
    end
  end
end
