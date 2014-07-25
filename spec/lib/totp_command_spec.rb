module TFA
  describe TotpCommand do
    subject { TotpCommand.new(storage) }
    let(:secret) { ::ROTP::Base32.random_base32 }
    let(:storage) { Storage.new(Tempfile.new('test').path) }

    before :each do
      storage.save('development', secret)
    end

    describe "#run" do
      it "returns a time based one time password for the authentication secret given" do
        correct_code = ::ROTP::TOTP.new(secret).now
        expect(subject.run(["development"])).to eql(correct_code)
      end
    end
  end
end
