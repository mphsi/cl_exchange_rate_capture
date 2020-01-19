RSpec.describe ExchangeRateManager do
  it "has a version number" do
    expect(ExchangeRateManager::VERSION).not_to be nil
  end

  class FakeFetcher
    def initialize(value, errors)
      @value  = value
      @errors = errors
    end

    def fetch_exchange_rate(day:)
      return @value
    end

    def errors
      return @errors
    end
  end

  class FakeInserter
    def initialize(inserted, errors)
      @inserted = inserted
      @errors   = errors
    end

    def insert_exchange_rate(value:, day:)
      return @inserted
    end

    def errors
      return @errors
    end
  end

  describe ExchangeRateManager::Manager do
    context "its interface" do
      before(:all) do
        @manager      = ExchangeRateManager::Manager.new
        @day_string   = Time.now.strftime("%F")
        @sample_value = 18.5432
      end
      it "defines #fetch_exchange_rate" do
        expect(@manager.respond_to?(:fetch_exchange_rate)).to eq(true)
      end
      it "defines #insert_exchange_rate" do
        expect(@manager.respond_to?(:insert_exchange_rate)).to eq(true)
      end
      describe "#fetch_exchange_rate" do
        it "returns a Hash with four required keys" do
          fetcher = FakeFetcher.new(@sample_value, [])
          result  = @manager.fetch_exchange_rate(
            day: @day_string, fetcher: fetcher)

          expect(result.has_key?("requested_day")).to eq(true)
          expect(result.has_key?("exchange_rate_found")).to eq(true)
          expect(result.has_key?("exchange_rate_value")).to eq(true)
          expect(result.has_key?("errors")).to eq(true)
        end
        context "when fetching an exchange rate is successful"
        context "when fetching an exchange rate is unsuccessful"
      end
      describe "#insert_exchange_rate" do
        it "returns a Hash with four required keys" do
          inserter = FakeInserter.new(true, [])
          result   = @manager.insert_exchange_rate(
            day:@day_string, value: @sample_value, inserter: inserter)

          expect(result.has_key?("requested_day")).to eq(true)
          expect(result.has_key?("exchange_rate_value")).to eq(true)
          expect(result.has_key?("exchange_rate_inserted")).to eq(true)
          expect(result.has_key?("errors")).to eq(true)
        end
        context "when inserting an exchange rate is successful"
        context "when inserting an exchange rate is unsuccessful"
      end
    end
  end
end
