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
        expect(@manager).to respond_to(:fetch_exchange_rate)
      end
      it "defines #insert_exchange_rate" do
        expect(@manager).to respond_to(:insert_exchange_rate)
      end
      describe "#fetch_exchange_rate" do
        context "when fetching an exchange rate is successful" do
          before(:all) do
            fetcher = FakeFetcher.new(@sample_value, [])
            @result = @manager.fetch_exchange_rate(
              day: @day_string, fetcher: fetcher)
          end
          it "returns a Hash with at least three required keys" do
            expect(@result).to include("requested_day")
            expect(@result).to include("exchange_rate_found")
            expect(@result).to include("exchange_rate_value")
          end
          context "the Hash ouput must contain" do
            it "the requested day" do
              expect(@result["requested_day"]).to eq(@day_string)
            end
            it "true as a flag for having found the exchange rate" do
              expect(@result["exchange_rate_found"]).to eq(true)
            end
            it "the exchange rate value for the day" do
              expect(@result["exchange_rate_value"]).not_to be_nil
              expect(@result["exchange_rate_value"].class).to eq(Float)
            end
          end
        end
        context "when fetching an exchange rate is unsuccessful" do
          before(:all) do
            fetcher = FakeFetcher.new(nil, ["Something happened"])
            @result = @manager.fetch_exchange_rate(
              day: @day_string, fetcher: fetcher)
          end
          it "returns a Hash with at least four required keys" do
            expect(@result).to include("requested_day")
            expect(@result).to include("exchange_rate_found")
            expect(@result).to include("exchange_rate_value")
            expect(@result).to include("errors")
          end
          context "the Hash ouput must contain" do
            it "the requested day" do
              expect(@result["requested_day"]).to eq(@day_string)
            end
            it "false as a flag for not having found the exchange rate" do
              expect(@result["exchange_rate_found"]).to eq(false)
            end
            it "nil as the exchange rate value for the day" do
              expect(@result["exchange_rate_value"]).to be_nil
            end
            it "a non empty errors array" do
              expect(@result["errors"].size).to be > 0
            end
          end
        end
      end
      describe "#insert_exchange_rate" do
        context "when inserting an exchange rate is successful" do
          before(:all) do
            inserter = FakeInserter.new(true, [])
            @result  = @manager.insert_exchange_rate(
              day: @day_string, value: @sample_value, inserter: inserter)
          end
          it "returns a Hash with at least three required keys" do
            expect(@result).to include("requested_day")
            expect(@result).to include("exchange_rate_value")
            expect(@result).to include("exchange_rate_inserted")
          end
          context "the Hash ouput must contain" do
            it "the requested day" do
              expect(@result["requested_day"]).to eq(@day_string)
            end
            it "the requested exchange rate to insert" do
              expect(@result["exchange_rate_value"]).to eq(@sample_value)
            end
            it "true as a flag for having inserted the exchange rate" do
              expect(@result["exchange_rate_inserted"]).to eq(true)
            end
          end
        end
        context "when inserting an exchange rate is unsuccessful" do
          before(:all) do
            inserter = FakeInserter.new(false, ["Something happened"])
            @result  = @manager.insert_exchange_rate(
              day:@day_string, value: @sample_value, inserter: inserter)
          end
          it "returns a Hash with at least four required keys" do
            expect(@result).to include("requested_day")
            expect(@result).to include("exchange_rate_value")
            expect(@result).to include("exchange_rate_inserted")
            expect(@result).to include("errors")
          end
          context "the Hash ouput must contain" do
            it "the requested day" do
              expect(@result["requested_day"]).to eq(@day_string)
            end
            it "the requested exchange rate to insert" do
              expect(@result["exchange_rate_value"]).to eq(@sample_value)
            end
            it "false as a flag for having inserted the exchange rate" do
              expect(@result["exchange_rate_inserted"]).to eq(false)
            end
            it "a non empty errors array" do
              expect(@result["errors"].size).to be > 0
            end
          end
        end
      end
    end
  end
end
