module TFA
  class Console
    def initialize(filename = "tfa")
      @storage = Storage.new(filename)
    end

    def run(arguments)
      command_name = arguments.first
      command_for(command_name).run(arguments - [command_name])
    end

    private

    def command_for(command_name)
      registry[command_name].call
    end

    def registry
      Hash.new { |x, y| lambda { UsageCommand.new(@storage) } }.tap do |commands|
        commands['add'] = lambda { AddCommand.new(@storage) }
        commands['show'] = lambda { ShowCommand.new(@storage) }
        commands['totp'] = lambda { TotpCommand.new(@storage) }
      end
    end
  end
end
