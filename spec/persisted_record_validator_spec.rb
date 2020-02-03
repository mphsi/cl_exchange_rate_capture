RSpec.describe ExchangeRateCapture::PersistedRecordValidator do
  describe "#call" do
    context "when :record attr. behaves like a Hash" do
      context "and it includes 'id', 'precio' and 'created_at' vals." do
        before do
          @validator = ExchangeRateCapture::PersistedRecordValidator.new(
            {"id" => 1, "precio" => 18.5432, "created_at" => "2012-01-01"}
          )
        end
        it "returns true" do
          expect(@validator.call).to eq(true)
        end
      end
      context "and it doesnt includes 'id', 'precio' and 'created_at' vals." do
        before do
          @validator = ExchangeRateCapture::PersistedRecordValidator.new(
            {"id" => nil, "precio" => "a", "created_at" => false}
          )
        end
        it "returns false" do
          expect(@validator.call).to eq(false)
        end
      end
    end
    context "when :record attr. does not behaves like a Hash" do
      before do
        @validator = ExchangeRateCapture::PersistedRecordValidator.new([])
      end
      it "returns false" do
        expect(@validator.call).to eq(false)
      end
    end
  end
end
