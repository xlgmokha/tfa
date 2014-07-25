module TFA
  describe ShowCommand do
    subject { ShowCommand.new(storage) }
    let(:storage) { PStore.new(Tempfile.new('blah').path) }

    it "retrieves the secret associated with the key given" do
      secret = SecureRandom.uuid
      storage.transaction do
        storage['production'] = secret
      end

      result = subject.run(['production'])
      expect(result).to eql(secret)
    end
  end
end
