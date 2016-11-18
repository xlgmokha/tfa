module TFA
  describe TotpCommand do
    subject { TotpCommand.new(storage) }
    let(:storage) { Storage.new(filename: SecureRandom.uuid) }

    def code_for(secret)
      ::ROTP::TOTP.new(secret).now
    end

    describe "#run" do
      context "when a single key is given" do
        let(:secret) { ::ROTP::Base32.random_base32 }

        it "returns a time based one time password for the authentication secret given" do
          storage.save("development", secret)
          expect(subject.run("development")).to eql(code_for(secret))
        end
      end

      context "when no arguments are given" do
        let(:development_secret) { ::ROTP::Base32.random_base32 }
        let(:staging_secret) { ::ROTP::Base32.random_base32 }

        it "returns the one time password for all keys" do
          storage.save("development", development_secret)
          storage.save("staging", staging_secret)
          expect(subject.run(nil)).to eql([
            { "development" => code_for(development_secret) },
            { "staging" => code_for(staging_secret) }
          ])
        end
      end

      context "when the key is not known" do
        it "returns with nothing" do
          expect(subject.run(["blah"])).to be_empty
        end
      end

      context "when the secret is invalid" do
        let(:invalid_secret) { "hello world" }

        before :each do
          storage.save("development", invalid_secret)
        end

        it "returns an error message" do
          expected = { "development" => "INVALID SECRET" }
          expect(subject.run(["development"])).to match_array([expected])
        end
      end
    end
  end
end
