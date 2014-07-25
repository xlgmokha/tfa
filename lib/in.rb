require "in/version"
require "pstore"

module In
  class Console
    def initialize(filename = "secrets", authenticator)
      @storage = PStore.new(File.join(Dir.home, ".#{filename}.pstore"))
      @authenticator = authenticator
    end

    def run(command)
      arguments = command.split(' ')
      command_name = arguments.first
      command_for(command_name).run(arguments - [command_name])
    end

    private

    def command_for(command_name)
      case command_name
      when "add"
        AddCommand.new(@storage)
      when "show"
        ShowCommand.new(@storage)
      when "totp"
        TotpCommand.new(@storage, @authenticator)
      end
    end
  end

  class AddCommand
    def initialize(storage)
      @storage = storage
    end

    def run(arguments)
      name = arguments.first
      secret = arguments.last
      @storage.transaction do
        @storage[name] = secret
      end
      "Added... "
    end
  end

  class ShowCommand
    def initialize(storage)
      @storage = storage
    end

    def run(arguments)
      name = arguments.last
      @storage.transaction(true) do
        @storage[name]
      end
    end
  end

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
