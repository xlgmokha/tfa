module TFA
  class AddCommand
    def initialize(storage)
      @storage = Storage.new(storage)
    end

    def run(arguments)
      name = arguments.first
      @storage.save(arguments.first, arguments.last)
      "Added #{name}"
    end
  end
end
