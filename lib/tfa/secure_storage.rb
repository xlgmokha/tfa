module TFA
  class SecureStorage
    def initialize(original, passphrase_request)
      @original = original
      @passphrase_request = passphrase_request
    end

    def encrypt!(algorithm = "AES-256-CBC")
      cipher = OpenSSL::Cipher.new(algorithm)
      cipher.encrypt
      cipher.key = digest
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
      data = JSON.parse(IO.read(@original.path), symbolize_names: true)
      decipher = OpenSSL::Cipher.new(data[:algorithm])
      decipher.decrypt
      decipher.key = digest
      decipher.iv = Base64.decode64(data[:iv])
      plain_text = decipher.update(Base64.decode64(data[:cipher_text]))
      IO.write(@original.path, plain_text + decipher.final)
    end

    def encrypted?
      return false unless File.exist?(@original.path)
      JSON.parse(IO.read(@original.path))
      true
    rescue JSON::ParserError
      false
    end

    private

    def method_missing(name, *args, &block)
      super unless @original.respond_to?(name)

      was_encrypted = encrypted?
      if was_encrypted
        encrypted_content = IO.read(@original.path)
        decrypt!
        original_sha256 = Digest::SHA256.file(@original.path)
      end
      result = @original.public_send(name, *args, &block)
      if was_encrypted
        new_sha256 = Digest::SHA256.file(@original.path)

        if original_sha256 == new_sha256
          IO.write(@original.path, encrypted_content)
        else
          encrypt!
        end
      end
      result
    end

    def respond_to_missing?(method, *)
      @original.respond_to?(method)
    end

    def digest
      @digest ||= Digest::SHA256.digest(@passphrase_request.call)
    end
  end
end
