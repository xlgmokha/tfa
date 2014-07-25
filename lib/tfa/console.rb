module TFA
  class Console
    def initialize(filename = "tfa")
      @storage = PStore.new(File.join(Dir.home, ".#{filename}.pstore"))
    end

    def run(arguments)
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
        TotpCommand.new(@storage)
      else
        UsageCommand.new(@storage)
      end
    end
  end
end
