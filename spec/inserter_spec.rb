RSpec.describe ExchangeRateCapture::Inserter do
  def valid_connections
    ExchangeRateCapture::DatabaseConnectionsGetter.call
  end
  describe "#call" do
    context "when no :db_connections are present" do
      before do
        @inserter = ExchangeRateCapture::Inserter.new(nil, nil, [])
      end
      it "returns an empty array" do
        expect(@inserter.call).to eq([])
      end
    end
    context "when :db_connections are present" do
      before do
        @conns    = valid_connections
        @inserter = ExchangeRateCapture::Inserter.new(nil, nil, @conns)
      end
      it "returns an array with a value for each connection" do
        expect(@inserter.call.size).to eq(@conns.size)
      end
    end
  end
end
