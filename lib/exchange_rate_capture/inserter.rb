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
          map_value_into_detailed_value(
            DBInserter.call(value, day, db_connection),
            db_connection
          )
        end
      rescue
        return []
      end
    end

    private

    def map_value_into_detailed_value(record, connection)
      status = record.nil? || record["id"].nil? ? "not inserted" : "inserted"

      {
        "status" => status,
        "database_name" => connection.database_name,
        "database_record" => record
      }
    end
  end
end
