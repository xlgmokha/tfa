module TFA
  describe CLI do
    subject { CLI.new }
    let(:secret) { ::ROTP::Base32.random_base32 }

    describe "#run" do
      context "when adding a key" do
        it "saves a new secret" do
          subject.add("development", secret)
          expect(subject.show("development")).to eql(secret)
        end
      end

      context "when getting a one time password" do
        it "creates a totp for a certain key" do
          subject.add("development", secret)
          expect(subject.totp("development")).to_not be_nil
        end
      end
    end
  end
end
