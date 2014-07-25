module TFA
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
      "Added #{name}"
    end
  end
end
