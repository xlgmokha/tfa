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
      cipher.encrypt
      cipher.key = Digest::SHA256.digest(passphrase)
      cipher.iv = cipher.random_iv

      plain_text = read_all
      cipher_text = cipher.update(plain_text) + cipher.final
      flush(cipher_text)
    end

    def decrypt!(passphrase)
      cipher_text = read_all
      decipher = cipher
      decipher.decrypt
      decipher.iv = cipher_text[0..decipher.iv_len-1]
      cipher.key = Digest::SHA256.digest(passphrase)
      data = cipher_text[decipher.iv_len..-1]
      flush(decipher.update(data) + decipher.final)
    end

    private

    def open_readonly
      @storage.transaction(true) do
        yield @storage
      end
    end

    def cipher
      @cipher ||= OpenSSL::Cipher.new("AES-256-CBC")
    end

    def read_all
      IO.read(path)
    end

    def flush(data)
      IO.write(path, data)
    end
  end
end
