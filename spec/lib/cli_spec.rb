module TFA
  describe CLI do
    subject { CLI.new }

    def code_for(secret)
      ::ROTP::TOTP.new(secret).now
    end

    let(:dev_secret) { ::ROTP::Base32.random_base32 }
    let(:prod_secret) { ::ROTP::Base32.random_base32 }

    describe "#add" do
      context "when a secret is added" do
        it "adds the secret" do
          subject.add("development", dev_secret)
          expect(subject.show("development")).to eql(dev_secret)
        end
      end

      context "when a full otpauth string is added" do
        it "strips out the url for just the secret" do
          url = "otpauth://totp/email@email.com?secret=#{dev_secret}&issuer="

          subject.add("development", url)
          expect(subject.show("development")).to eql(dev_secret)
        end
      end
    end

    describe "#show" do
      context "when a single key is given" do
        it "returns the secret" do
          subject.add("development", dev_secret)
          expect(subject.show("development")).to eql(dev_secret)
        end
      end

      context "when no key is given" do
        it "returns the secret for all keys" do
          subject.add("development", dev_secret)
          subject.add("production", prod_secret)

          result = subject.show.to_s
          expect(result).to include(dev_secret)
          expect(result).to include(prod_secret)
        end
      end
    end

    describe "#totp" do
      context "when a single key is given" do
        it "returns a time based one time password" do
          subject.add("development", dev_secret)
          expect(subject.totp("development")).to eql(code_for(dev_secret))
        end
      end

      context "when no key is given" do
        it "returns a time based one time password for all keys" do
          subject.add("development", dev_secret)
          subject.add("production", prod_secret)

          result = subject.totp.to_s
          expect(result).to include(code_for(dev_secret))
          expect(result).to include(code_for(prod_secret))
        end
      end
    end

    describe "#destroy" do
      let(:name) { "development" }

      it 'removes the secret with the given name' do
        subject.add(name, dev_secret)
        subject.destroy(name)

        expect(subject.show(name)).to be_nil
      end
    end
  end
end
