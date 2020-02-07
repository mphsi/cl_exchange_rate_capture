RSpec.describe ExchangeRateCapture::DatabaseConnectionsGetter do
  describe "#call" do
    before do
      @getter = ExchangeRateCapture::DatabaseConnectionsGetter.new()
      @creds  = @getter.credentials
      @conns  = @getter.call
    end
    it "returns an object for each set of credentials" do
      expect(@creds.size).to eq(@conns.size)
    end
    it "returns a DBConnection for each set of credentials" do
      expect(@conns).to all( be_an(ExchangeRateCapture::DBConnection) )
    end
  end
end
