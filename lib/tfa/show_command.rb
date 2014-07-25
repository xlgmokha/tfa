module TFA
  class ShowCommand
    def initialize(storage)
      @storage = Storage.new(storage)
    end

    def run(arguments)
      return @storage.secret_for(arguments.last) if arguments.any?
      @storage.all_secrets
    end
  end
end
