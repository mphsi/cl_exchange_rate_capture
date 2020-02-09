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
      it "appends a status, database_name and database_record keys" +
         "to each returned value" do
        expect(@values).to all(include(
          "status", "database_name", "database_record"
        ))
      end
    end
  end
end
