module In
  describe Console do
    subject { Console.new('testing') }
    let(:secret) { SecureRandom.uuid }

    it "saves a new secret" do
      subject.run("add development #{secret}")
      expect(subject.run("show development")).to eql(secret)
    end
  end
end
