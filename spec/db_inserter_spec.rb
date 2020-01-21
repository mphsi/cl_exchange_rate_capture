require "./env_variables"

RSpec.describe ExchangeRateManager::DBInserter do
  def new_inserter
    ExchangeRateManager::DBInserter.new
  end

  context "its interface" do
    before(:all) do
      @inserter = new_inserter
    end
    it "defines #test_connection" do
      expect(@inserter).to respond_to(:test_connection)
    end
    it "defines #insert_exchange_rate" do
      expect(@inserter).to respond_to(:test_connection)
    end
  end
end
