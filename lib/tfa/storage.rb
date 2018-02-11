module TFA
  class Storage
    include Enumerable
    attr_reader :path

    def initialize(path)
      @path = path
      @storage =
        if ".pstore" == File.extname(path)
          PStore.new(path)
        else
          YAML::Store.new(path)
        end
    end

    def each
      all.each do |each|
        yield each
      end
    end

    def all
      open_readonly do |storage|
        storage.roots.map { |key| { key => storage[key] } }
      end
    end

    def secret_for(key)
      open_readonly do |storage|
        storage[key]
      end
    end

    def save(key, value)
      @storage.transaction do
        @storage[key] = value
      end
    end

    def delete(key)
      @storage.transaction do
        @storage.delete(key)
      end
    end

    def encrypt!(passphrase)
      cipher = OpenSSL::Cipher.new("AES-256-CBC")
      cipher.encrypt
      cipher.key = digest_for(passphrase)
      #iv = cipher.random_iv
      #cipher.iv = iv

      plain_text = read_all
      #cipher_text = iv + cipher.update(plain_text) + cipher.final
      cipher_text = cipher.update(plain_text) + cipher.final
      flush(cipher_text)
    end

    def decrypt!(passphrase)
      cipher_text = read_all
      decipher = OpenSSL::Cipher.new("AES-256-CBC")
      decipher.decrypt
      #decipher.iv = cipher_text[0..decipher.iv_len-1]
      decipher.key = digest_for(passphrase)
      #data = cipher_text[decipher.iv_len..-1]
      data = cipher_text
      flush(decipher.update(data) + decipher.final)
    end

    private

    def open_readonly
      @storage.transaction(true) do
        yield @storage
      end
    end

    def read_all
      IO.read(path)
    end

    def flush(data)
      IO.write(path, data)
    end

    def digest_for(passphrase)
      Digest::SHA256.digest(passphrase)
    end
  end
end
