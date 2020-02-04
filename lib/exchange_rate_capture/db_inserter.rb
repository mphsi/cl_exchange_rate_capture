module ExchangeRateCapture
  class DBInserter
    def self.call(
      value,
      day,
      connection = ExchangeRateCapture::DBConnection.new
    )
      new(value, day, connection).call
    end

    attr_reader :value, :day
    def initialize(value, day, connection)
      @value      = value
      @day        = day
      @connection = connection
    end

    def call
      begin
        if (existing_record = get_record_in_day).nil?
          return insert_record
        else
          return existing_record
        end
      rescue
        return nil
      end
    end

    def get_record_in_day
      @connection.exec(%{
        SELECT * FROM tipo_cambios
        WHERE nombre = 'USD/MXN'
        AND created_at = '#{day}'::date;
      }).first
    end

    def insert_record
      @connection.exec(%{
        INSERT INTO tipo_cambios(
          nombre, precio, created_at, updated_at
        ) VALUES(
          'USD/MXN', #{value}::numeric, '#{day}'::date, '#{day}'::date
        ) RETURNING *;
      }).first
    end
  end
end
