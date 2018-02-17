module TFA
  describe SecureStorage do
    subject { described_class.new(original, passphrase) }
    let(:original) { Tempfile.new("tfa") }
    let(:passphrase) { -> { SecureRandom.uuid } }

    after { original.unlink }

    describe "decrypt!" do
      let(:message) { JSON.generate(secret: SecureRandom.uuid) }

      it "decrypts an encrypted file" do
        IO.write(original.path, message)
        subject.encrypt!
        subject.decrypt!
        expect(IO.read(original.path)).to eql(message)
      end
    end

    describe "encrypt!" do
      let(:message) { JSON.generate(secret: SecureRandom.uuid) }

      it "encrypts a file" do
        IO.write(original.path, message)
        subject.encrypt!
        expect(IO.read(original.path)).to_not eql(message)
      end
    end
  end
end
