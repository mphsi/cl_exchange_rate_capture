RSpec.describe ExchangeRateCapture::DBInserter do
  def connection
    ExchangeRateCapture::DBConnection.new
  end

  def sample_day
    Time.now.strftime("%F")
  end

  def sample_value
    18.5432
  end

  describe "#call" do
    context "when a connection with the database is available" do
      context "and :day and :value attributes are valid" do
        before(:all) do
          @inserter = ExchangeRateCapture::DBInserter.new(
            sample_value, sample_day, connection
          )
          @result = @inserter.call
        end
        it "returns a Hash" do
          expect(@result.class).to eq(Hash)
        end
        it "includes a 'id' value" do
          expect(@result).to include("id")
        end
        it "includes a 'precio' value" do
          expect(@result).to include("precio")
        end
        it "includes a 'created_at' value" do
          expect(@result).to include("created_at")
        end
      end
      context "and :day and :value attributes are not valid" do
        before do
          @inserter = ExchangeRateCapture::DBInserter.new(
            sample_value, "2020-01-99", connection
          )
        end
        it "returns nil" do
          result = @inserter.call
          expect(result).to be_nil
        end
      end
    end
  end
end
