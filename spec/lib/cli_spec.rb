module TFA
  describe CLI do
    subject { CLI.new }

    def code_for(secret)
      ::ROTP::TOTP.new(secret).now
    end

    let(:secret) { ::ROTP::Base32.random_base32 }

    describe "#add" do
      context "when a secret is added" do
        it "adds the secret" do
          subject.add("development", secret)
          expect(subject.show("development")).to eql(secret)
        end
      end

      context "when a full otpauth string is added" do
        it "strips out the url for just the secret" do
          url = "otpauth://totp/email@email.com?secret=#{secret}&issuer="

          subject.add("development", url)
          expect(subject.show("development")).to eql(secret)
        end
      end
    end

    describe "#totp" do
      context "when a single key is given" do
        it "returns a time based one time password" do
          subject.add("development", secret)
          expect(subject.totp("development")).to eql(code_for(secret))
        end
      end
    end
  end
end
