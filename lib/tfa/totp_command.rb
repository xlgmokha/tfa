module TFA
  class TotpCommand
    def initialize(storage)
      @storage = storage
    end

    def run(arguments)
      ::ROTP::TOTP.new(@storage.secret_for(arguments.first)).now
    end
  end
end
