RSpec.describe ExchangeRateCapture::ApiFetcher do
  def valid_day
    "2020-01-01"
  end

  def invalid_day
    "2020-01-99"
  end

  describe "#call" do
    context "when the API is accessible" do
      context "and a value exists for the given :day attr" do
        before do
          @fetcher = ExchangeRateCapture::ApiFetcher.new(valid_day)
        end
        it "returns a Float" do
          result = @fetcher.call
          expect(result.class).to eq(Float)
        end
      end
      context "and a value doesnt exists for the given :day attr" do
        before do
          @fetcher = ExchangeRateCapture::ApiFetcher.new(invalid_day)
        end
        it "returns nil" do
          result = @fetcher.call
          expect(result).to be_nil
        end
      end
    end
  end
end
