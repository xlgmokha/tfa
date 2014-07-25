module In
  class TotpCommand
    def initialize(storage, authenticator)
      @storage = storage
      @authenticator = authenticator
    end

    def run(arguments)
      name = arguments.first
      secret = @storage.transaction(true) do
        @storage[name]
      end
      @authenticator.totp(secret)
    end
  end
end
