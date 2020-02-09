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
        @values   = @inserter.call
      end
      it "returns an array with a value for each connection" do
        expect(@values.size).to eq(@conns.size)
      end
      it "appends a _status and _database_name keys to each returned value" do
        expect(@values).to all(include("_status", "_database_name"))
      end
    end
  end
end
