RSpec.describe ExchangeRateManager do
  it "has a version number" do
    expect(ExchangeRateManager::VERSION).not_to be nil
  end

  describe ExchangeRateManager::Manager do
    context "its interface" do
      before(:all) do
        @manager = ExchangeRateManager::Manager.new
      end
      it "defines a fetch_exchange_rate method" do
        expect(@manager.respond_to?(:fetch_exchange_rate)).to eq(true)
      end
      it "defines an insert_exchange_rate method" do
        expect(@manager.respond_to?(:insert_exchange_rate)).to eq(true)
      end
    end
  end
end
