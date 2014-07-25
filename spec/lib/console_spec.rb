module TFA
  describe Console do
    subject { Console.new('testing') }
    let(:secret) { ::ROTP::Base32.random_base32 }

    describe "#run" do
      context "when adding a key" do
        it "saves a new secret" do
          subject.run(["add", "development", secret])
          expect(subject.run(["show", "development"])).to eql(secret)
        end
      end

      context "when getting a one time password" do
        it "creates a totp for a certain key" do
          subject.run(["add", "development", secret])
          expect(subject.run(["totp", "development"])).to_not be_nil
        end
      end

      context "when running an unknown command" do
        it "returns the usage" do
          expect(subject.run([])).to_not be_nil
        end
      end
    end
  end
end
