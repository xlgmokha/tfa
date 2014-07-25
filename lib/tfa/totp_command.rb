module TFA
  class TotpCommand
    def initialize(storage)
      @storage = storage
    end

    def run(arguments)
      return password_for(secret_for(arguments.first)) if arguments.any?
      all_passwords
    end

    private

    def password_for(secret)
      ::ROTP::TOTP.new(secret).now
    end

    def all_passwords
      secrets = @storage.all_secrets
      secrets.each do |hash|
        hash[hash.keys.first] = password_for(hash[hash.keys.first])
      end
      secrets
    end

    def secret_for(key)
      @storage.secret_for(key)     
    end
  end
end
