RSpec.describe ExchangeRateManager::SIEApiFetcher do
  def new_fetcher
    ExchangeRateManager::SIEApiFetcher.new
  end

  def invalid_day_error_message
    "Invalid day"
  end

  def valid_day
    "2020/01/01"
  end

  def invalid_day
    "2020/01/32"
  end

  context "its interface" do
    before(:all) do
      @fetcher = new_fetcher
    end
    it "defines #fetch_exchange_rate" do
      expect(@fetcher).to respond_to(:fetch_exchange_rate)
    end
    it "defines #errors" do
      expect(@fetcher).to respond_to(:errors)
    end
  end
  describe "#fetch_exchange_rate" do
    before(:all) do
      @fetcher = new_fetcher
    end
    context "when the day parameter is a valid Date" do
      it "returns a Float value" do
        result = @fetcher.fetch_exchange_rate(day: valid_day)
        expect(result.class).to eq(Float)
      end
    end
    context "when the day parameter is not a valid Date" do
      it "returns a nil value" do
        result = @fetcher.fetch_exchange_rate(day: invalid_day)
        expect(result).to eq(nil)
      end
    end
  end
  describe "#errors" do
    context "when #fetch_exchange_rate has already been called" do
      it "returns an Array" do
        @fetcher = new_fetcher
        @fetcher.fetch_exchange_rate(day: nil)
        expect(@fetcher.errors.class).to eq(Array)
      end
      context "when the day parameter is a valid Date" do
        before(:all) do
          @fetcher = new_fetcher
          @value   = @fetcher.fetch_exchange_rate(day: valid_day)
          @result  = @fetcher.errors
        end
        it "returns an array without an invalid day error message" do
          expect(@result).to_not include(invalid_day_error_message)
        end
      end
      context "when the day parameter is not a valid Date" do
        before(:all) do
          @fetcher = new_fetcher
          @value   = @fetcher.fetch_exchange_rate(day: invalid_day)
          @result  = @fetcher.errors
        end
        it "returns an array with an invalid day error message" do
          expect(@result).to include(invalid_day_error_message)
        end
      end
    end
    context "when #fetch_exchange_rate has not already been called" do
      it "returns nil" do
        @fetcher = new_fetcher
        expect(@fetcher.errors).to be_nil
      end
    end
  end
end
