module TFA
  class ShowCommand
    def initialize(storage)
      @storage = storage
    end

    def run(arguments)
      if arguments.any?
        name = arguments.last
        @storage.transaction(true) do
          @storage[name]
        end
      else
        @storage.transaction(true) do
          @storage.roots.map do |key|
            @storage[key]
          end
        end
      end
    end
  end
end
