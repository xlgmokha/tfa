module In
  class TotpCommand
    def initialize(storage)
      @storage = storage
    end

    def run(arguments)
      name = arguments.first
      ::ROTP::TOTP.new(secret_for(name)).now
    end

    private

    def secret_for(name)
      @storage.transaction(true) do
        @storage[name]
      end
    end
  end
end
