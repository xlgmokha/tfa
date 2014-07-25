module TFA
  describe TotpCommand do
    subject { TotpCommand.new(storage) }
    let(:storage) { Storage.new(Tempfile.new('test').path) }
    let(:storage) { Storage.new(SecureRandom.uuid) }

    def code_for(secret)
      ::ROTP::TOTP.new(secret).now
    end

    describe "#run" do
      context "when a single key is given" do
        let(:secret) { ::ROTP::Base32.random_base32 }

        it "returns a time based one time password for the authentication secret given" do
          storage.save('development', secret)
          expect(subject.run(["development"])).to eql(code_for(secret))
        end
      end

      context "when no arguments are given" do
        let(:development_secret) { ::ROTP::Base32.random_base32 }
        let(:staging_secret) { ::ROTP::Base32.random_base32 }

        it "returns the one time password for all keys" do
          storage.save('development', development_secret)
          storage.save('staging', staging_secret)
          expect(subject.run([])).to eql([
            { 'development' => code_for(development_secret) }, 
            { 'staging' => code_for(staging_secret) }
          ])
        end
      end
    end
  end
end
