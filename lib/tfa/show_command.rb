module TFA
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
