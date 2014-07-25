module TFA
  describe Console do
    subject { Console.new('testing') }
    let(:secret) { ::ROTP::Base32.random_base32 }

    it "saves a new secret" do
      subject.run(["add", "development", secret])
      expect(subject.run(["show", "development"])).to eql(secret)
    end

    it "creates a totp for a certain key" do
      subject.run(["add", "development", secret])
      expect(subject.run(["totp", "development"])).to_not be_nil
    end
  end
end
