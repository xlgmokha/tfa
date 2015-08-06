module TFA
  describe CLI do
    subject { CLI.new }

    def code_for(secret)
      ::ROTP::TOTP.new(secret).now
    end

    describe "#totp" do
      context "when a single key is given" do
        let(:secret) { ::ROTP::Base32.random_base32 }

        it "returns a time based one time password for the authentication secret given" do
          subject.add('development', secret)
          expect(subject.totp("development")).to eql(code_for(secret))
        end
      end
    end
  end
end
