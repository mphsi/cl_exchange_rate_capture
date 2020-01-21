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

  def new_inserter
    ExchangeRateManager::DBInserter.new
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
      describe "#insert_exchange_rate" do
        # todo
      end
      describe "#connection_works?" do
        it "returns true"
      end
      describe "#errors" do
        it "returns an empty array"
      end
    end
    context "when a working connection to the config. DB is not present" do
      describe "#insert_exchange_rate" do
        it "returns nil"
      end
      describe "#connection_works?" do
        it "returns false"
      end
      describe "#errors" do
        it "includes a DB connection error message"
      end
    end
  end
end
