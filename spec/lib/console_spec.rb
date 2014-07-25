module In
  describe Console do
    subject { Console.new('testing', authenticator) }
    let(:secret) { SecureRandom.uuid }
    let(:authenticator) { Object.new }

    it "saves a new secret" do
      subject.run("add development #{secret}")
      expect(subject.run("show development")).to eql(secret)
    end

    it "creates a totp for a certain key" do
      totp = rand(100)
      subject.run("add development #{secret}")

      authenticator.stub(:totp).with(secret).and_return(totp)
      expect(subject.run("totp development")).to eql(totp)
    end
  end
end
