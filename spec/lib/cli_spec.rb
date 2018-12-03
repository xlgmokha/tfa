module TFA
  describe CLI do
    subject { CLI.new([], filename: SecureRandom.uuid, directory: Dir.tmpdir, passphrase: passphrase) }
    let(:passphrase) { SecureRandom.uuid }

    def code_for(secret)
      ::ROTP::TOTP.new(secret).now
    end

    let(:dev_secret) { ::ROTP::Base32.random_base32 }
    let(:prod_secret) { ::ROTP::Base32.random_base32 }

    describe "#add" do
      let(:key) { SecureRandom.uuid }

      context "when a secret is added" do
        it "adds the secret" do
          subject.add(key, dev_secret)
          expect(subject.show(key)).to eql(dev_secret)
        end
      end

      context "when a full otpauth string is added" do
        it "strips out the url for just the secret" do
          url = "otpauth://totp/email@email.com?secret=#{dev_secret}&issuer="

          subject.add(key, url)
          expect(subject.show(key)).to eql(dev_secret)
        end
      end
    end

    describe "#show" do
      context "when a single key is given" do
        let(:key) { SecureRandom.uuid }

        it "returns the secret" do
          subject.add(key, dev_secret)
          expect(subject.show(key)).to eql(dev_secret)
        end
      end

      context "when no key is given" do
        it "returns the name of each item" do
          key = SecureRandom.uuid
          subject.add(key, dev_secret)
          subject.add("production", prod_secret)

          result = subject.show.to_s
          expect(result).to include(key)
          expect(result).to include("production")
        end
      end
    end

    describe "#totp" do
      context "when a single key is given" do
        it "returns a time based one time password" do
          key = SecureRandom.uuid
          subject.add(key, dev_secret)
          expect(subject.totp(key)).to eql(code_for(dev_secret))
        end
      end
    end

    describe "#destroy" do
      let(:name) { "development" }

      it "removes the secret with the given name" do
        subject.add(name, dev_secret)
        subject.destroy(name)

        expect(subject.show(name)).to be_nil
      end
    end

    describe "#now" do
      it "returns a time based one time password for the given secret" do
        expect(subject.now(dev_secret)).to eql(code_for(dev_secret))
      end
    end
  end
end
