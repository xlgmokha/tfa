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
end
