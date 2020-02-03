RSpec.describe ExchangeRateCapture::Capturist do
  before do
    @capturist = ExchangeRateCapture::Capturist.new
  end
  it { should respond_to(:capture) }
  describe "#capture" do
    it "should perform and log a bunch of actions"
  end
end
