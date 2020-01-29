require "./env_variables"

RSpec.describe ExchangeRateManager::DBInserter do
  # No need to test the actual connection to the database
  class FakeDBConnection
    def initialize(expected_result = nil)
      @expected_result = expected_result
    end

    def exec(query_string = "")
      @expected_result
    end

    def close
      return nil
    end
  end

  def new_inserter(connection = nil)
    ExchangeRateManager::DBInserter.new(connection: connection)
  end

  def sample_day
    Time.now.strftime("%F")
  end

  def sample_value
    18.5432
  end

  def db_connection_error
    "ExchangeRateManager::DBInserter : invalid connection"
  end

  def invalid_value_error
    "ExchangeRateManager::DBInserter : Invalid float"
  end

  def invalid_day_error
    "ExchangeRateManager::DBInserter : Invalid day"
  end

  def insert_exchange_rate_record_on_day(day, connection)
    connection.exec(%{
      INSERT INTO tipo_cambios(nombre, precio, created_at, updated_at)
      VALUES (
        'USD/MXN', #{sample_value}, '#{day}', '#{day}'
      );
    })
  end

  def remove_exchange_rate_record_on_day(day, connection)
    connection.exec(%{
      REMOVE FROM tipo_cambios WHERE ID = (
        SELECT id FROM tipo_cambios
        WHERE name = 'USD/MXN'
        AND precio = #{sample_value}
        AND created_at::date = '#{day}'::date,
        AND updated_at::date = '#{day}'::date
      );
    })
  end

  context "its interface" do
    before(:all) do
      @inserter = new_inserter
    end
    it "defines #insert_exchange_rate" do
      expect(@inserter).to respond_to(:insert_exchange_rate)
    end
    it "defines #connection_works?" do
      expect(@inserter).to respond_to(:connection_works?)
    end
    it "defines #errors" do
      expect(@inserter).to respond_to(:errors)
    end
    context "when a working connection to the config. DB is present" do
      before(:all) do
        @connection = ExchangeRateManager::DBConnection.new
        @inserter   = new_inserter(@connection)
      end
      context "once the instance has been created" do
        describe "#errors" do
          it "returns an empty array" do
            expect(@inserter.errors).to eq([])
          end
        end
      end
      describe "#connection_works?" do
        it "returns true" do
          expect(@inserter.connection_works?).to eq(true)
        end
      end
      describe "#insert_exchange_rate" do
        context "when the day is a valid Date string" do
          context "and an Exchange Rate already exists" do
            before(:all) do
              insert_exchange_rate_record_on_day(sample_day, @connection)
            end
            it "returns the existing record" do
              result = @inserter.insert_exchange_rate(
                day: sample_day, value: sample_value
              )
              expect(result["id"]).not_to be_nil
              expect(result["id"].to_i).to be_an(Integer)
            end
          end
          context "and an Exchange Rate doe not exists" do
            before(:all) do
              remove_exchange_rate_record_on_day(sample_day, @connection)
            end
            it "returns the created record" do
              result = @inserter.insert_exchange_rate(
                day: sample_day, value: sample_value
              )
              expect(result["id"]).not_to be_nil
              expect(result["id"].to_i).to be_an(Integer)
            end
          end
        end
        context "and the day is an invalid Date string" do
          before(:all) do
            @result = @inserter.insert_exchange_rate(
              day: "1999-01-33", value: sample_value
            )
          end
          it "returns false" do
            expect(@result).to eq(false)
          end
          it "appends an error to the #errors response" do
            expect(@inserter.errors).to include(invalid_day_error)
          end
        end
        context "when the value is a four decimals Float" do
          context "and an Exchange Rate already exists" do
            before(:all) do
              insert_exchange_rate_record_on_day(sample_day, @connection)
            end
            it "returns the existing record" do
              result = @inserter.insert_exchange_rate(
                day: sample_day, value: sample_value
              )
              expect(result["id"]).not_to be_nil
              expect(result["id"].to_i).to be_an(Integer)
            end
          end
          context "and an Exchange Rate does not exists" do
            before(:all) do
              remove_exchange_rate_record_on_day(sample_day, @connection)
            end
            it "returns the created record" do
              result = @inserter.insert_exchange_rate(
                day: sample_day, value: sample_value
              )
              expect(result["id"]).not_to be_nil
              expect(result["id"].to_i).to be_an(Integer)
            end
          end
        end
        context "when the value is not a four decimals Float" do
          before(:all) do
            @result = @inserter.insert_exchange_rate(
              day: sample_day, value: 18.654321
            )
          end
          it "returns false" do
            expect(@result).to eq(false)
          end
          it "appends an error to the #errors response" do
            expect(@inserter.errors).to include(invalid_value_error)
          end
        end
      end
    end
    context "when a working connection to the config. DB is not present" do
      before(:all) do
        @inserter = new_inserter(FakeDBConnection.new(nil))
      end
      describe "#insert_exchange_rate" do
        it "returns nil" do
          result = @inserter.insert_exchange_rate(
            day: sample_day, value: sample_value
          )
          expect(result).to eq(false)
        end
      end
      describe "#connection_works?" do
        it "returns false" do
          result = @inserter.connection_works?
          expect(result).to eq(false)
        end
      end
      describe "#errors" do
        it "includes a DB connection error message" do
          expect(@inserter.errors).to include(db_connection_error)
        end
      end
    end
  end
end
