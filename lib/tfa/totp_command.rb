module TFA
  class TotpCommand
    def initialize(storage)
      @storage = storage
    end

    def run(name)
      secret = secret_for(name)
      secret ? password_for(secret) : all_passwords
    end

    private

    def password_for(secret)
      ::ROTP::TOTP.new(secret).now
    end

    def all_passwords
      @storage.all_secrets.tap do |secrets|
        secrets.each do |hash|
          hash[hash.keys.first] = password_for(hash[hash.keys.first])
        end
      end
    end

    def secret_for(key)
      @storage.secret_for(key)
    end
  end
end
