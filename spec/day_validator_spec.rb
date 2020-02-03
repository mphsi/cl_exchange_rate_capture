RSpec.describe ExchangeRateCapture::DayValidator do
  describe "#call" do
    context "when the :day attribute is a valid Date" do
      before do
        @validator = ExchangeRateCapture::DayValidator.new("2020-01-01")
      end
      it "returns true" do
        expect(@validator.call).to eq(true)
      end
    end
    context "when the :day attribute is not a valid Date" do
      before do
        @validator = ExchangeRateCapture::DayValidator.new("2020-01-99")
      end
      it "returns false" do
        expect(@validator.call).to eq(false)
      end
    end
  end
end
