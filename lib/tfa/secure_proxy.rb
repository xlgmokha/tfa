module TFA
  class SecureProxy
    def initialize(original, passphrase)
      @original = original
      @digest = Digest::SHA256.digest(passphrase)
    end

    def encrypt!(algorithm = "AES-256-CBC")
      cipher = OpenSSL::Cipher.new(algorithm)
      cipher.encrypt
      cipher.key = @digest
      cipher.iv = iv = cipher.random_iv
      plain_text = IO.read(@original.path)
      json = JSON.generate(
        algorithm: algorithm,
        iv: Base64.encode64(iv),
        cipher_text: Base64.encode64(cipher.update(plain_text) + cipher.final),
      )
      IO.write(@original.path, json)
    end

    def decrypt!
      return unless File.exist?(@original.path)

      data = JSON.parse(IO.read(@original.path), symbolize_names: true)
      decipher = OpenSSL::Cipher.new(data[:algorithm])
      decipher.decrypt
      decipher.key = @digest
      decipher.iv = Base64.decode64(data[:iv])
      IO.write(@original.path, decipher.update(Base64.decode64(data[:cipher_text])) + decipher.final)
    end

    private

    def method_missing(name, *args, &block)
      super unless @original.respond_to?(name)

      decrypt!
      result = @original.public_send(name, *args, &block)
      encrypt!
      result
    end
  end
end
