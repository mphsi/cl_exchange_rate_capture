module ExchangeRateManager
  class DBInserter
    attr_reader :connection, :errors
    def initialize(
      connection: ExchangeRateManager::DBConnection.new,
      date_parser: ExchangeRateManager::DateParser.new,
      float_parser: ExchangeRateManager::FloatParser.new
    )
      @connection   = connection
      @date_parser  = date_parser
      @float_parser = float_parser
      @errors       = []
      connection_works?
    end

    def connection_works?
      return test_connection
    end

    def insert_exchange_rate(day:, value:)
      day   = validate_and_parse_day(day)
      value = validate_and_parse_value(value)

      return false unless @errors.empty?

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

    private

    def test_connection
      if test_output == connection_test_expected_output
        @errors -= [db_connection_error]
      else
        @errors += [db_connection_error]
      end
      @errors.include?(db_connection_error) == false
    end

    def db_connection_error
      "ExchangeRateManager::DBInserter : invalid connection"
    end

    def test_output
      begin
        @connection.exec(%{
          select (5 + 5) as output
        }).first["output"].to_i # parse result
      rescue
        nil
      end
    end

    def connection_test_expected_output
      10
    end

    def validate_and_parse_day(day)
      parsed_day = @date_parser.parse_date(day)

      if parsed_day.nil?
        @errors += ["#{self.class.name} : #{@date_parser.error_message}"]
      else
        @errors -= ["#{self.class.name} : #{@date_parser.error_message}"]
      end

      parsed_day
    end

    def validate_and_parse_value(value)
      parsed_value = @float_parser.parse_float(value)

      if parsed_value.nil?
        @errors += ["#{self.class.name} : #{@float_parser.error_message}"]
      else
        @errors -= ["#{self.class.name} : #{@float_parser.error_message}"]
      end

      parsed_value
    end
  end
end
