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
        @connection.exec(%{
          INSERT INTO tipo_cambios(
            nombre, precio, created_at, updated_at
          ) VALUES(
            'USD/MXN', #{value}::numeric, '#{day}'::date, '#{day}'::date
          ) RETURNING *;
        }).first
      rescue
        return nil
      end
    end
  end
end
