module TFA
  class AddCommand
    def initialize(storage)
      @storage = Storage.new(storage)
    end

    def run(arguments)
      name = arguments.first
      secret = arguments.last
      @storage.save(name, secret)
      "Added #{name}"
    end
  end
end
