module TFA
  class SecureProxy
    def initialize(original, passphrase)
      @original = original
      @digest = Digest::SHA256.digest(passphrase)
    end

    def encrypt!
      cipher = OpenSSL::Cipher.new("AES-256-CBC")
      cipher.encrypt
      cipher.key = @digest
      #iv = cipher.random_iv
      #cipher.iv = iv

      plain_text = read_all
      #cipher_text = iv + cipher.update(plain_text) + cipher.final
      cipher_text = cipher.update(plain_text) + cipher.final
      flush(cipher_text)
    end

    def decrypt!
      return unless File.exist?(@original.path)

      cipher_text = read_all
      decipher = OpenSSL::Cipher.new("AES-256-CBC")
      decipher.decrypt
      #decipher.iv = cipher_text[0..decipher.iv_len-1]
      decipher.key = @digest
      #data = cipher_text[decipher.iv_len..-1]
      data = cipher_text
      flush(decipher.update(data) + decipher.final)
    end

    private

    def method_missing(name, *args, &block)
      super unless @original.respond_to?(name)

      decrypt!
      result = @original.public_send(name, *args, &block)
      encrypt!
      result
    end

    def read_all
      IO.read(@original.path)
    end

    def flush(data)
      IO.write(@original.path, data)
    end
  end
end
