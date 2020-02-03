RSpec.describe ExchangeRateCapture::ValueValidator do
  describe "#call" do
    context "when :value attr. is a Float with no more than 4 decimals" do
      before do
        @validator = ExchangeRateCapture::ValueValidator.new(18.5432)
      end
      it "returns true" do
        expect(@validator.call).to eq(true)
      end
    end
    context "when :value attr. is a Float with more than 4 decimals" do
      before do
        @validator = ExchangeRateCapture::ValueValidator.new(18.654321)
      end
      it "returns false" do
        expect(@validator.call).to eq(false)
      end
    end
  end
end
