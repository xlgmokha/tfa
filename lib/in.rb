require "in/version"
require "pstore"

module In
  class Console
    def initialize(filename = "secrets")
      @storage = PStore.new(File.join(Dir.home, ".#{filename}.pstore"))
    end

    def run(command)
      arguments = command.split(' ')
      command_name = arguments.first
      command_for(command_name).run(arguments - [command_name])
    end

    private

    def command_for(command_name)
      if command_name == "add"
        AddCommand.new(@storage)
      else
        ShowCommand.new(@storage)
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
end
