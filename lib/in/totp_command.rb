module In
  class TotpCommand
    def initialize(storage)
      @storage = storage
    end

    def run(arguments)
      name = arguments.first
      secret = @storage.transaction(true) do
        @storage[name]
      end
      ::ROTP::TOTP.new(secret).now
    end
  end
end
