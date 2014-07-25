module TFA
  describe ShowCommand do
    subject { ShowCommand.new(storage) }
    let(:storage) { PStore.new(Tempfile.new('blah').path) }

    describe "#run" do
      context "when looking up the secret for a specific key" do
        it "retrieves the secret associated with the key given" do
          secret = SecureRandom.uuid
          storage.transaction do
            storage['production'] = secret
          end

          result = subject.run(['production'])
          expect(result).to eql(secret)
        end
      end

      context "when a specific name is not given" do
        it "returns all the secrets" do
          storage.transaction do
            storage['development'] = "1"
            storage['staging'] = "2"
            storage['production'] = "3"
          end

          expect(subject.run([])).to eql([{"development" => "1"}, { "staging" => "2" }, { "production" => "3" }])
        end
      end
    end
  end
end
