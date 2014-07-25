module TFA
  class TotpCommand
    def initialize(storage)
      @storage = Storage.new(storage)
    end

    def run(arguments)
      ::ROTP::TOTP.new(@storage.secret_for(arguments.first)).now
    end
  end
end
