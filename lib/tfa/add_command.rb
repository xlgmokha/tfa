module TFA
  class AddCommand
    def initialize(storage)
      @storage = storage
    end

    def run(arguments)
      name = arguments.first
      @storage.save(arguments.first, arguments.last)
      "Added #{name}"
    end
  end
end
