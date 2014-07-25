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

module TFA
  class Storage
    def initialize(storage)
      @storage = storage
    end

    def all_secrets
      open_readonly do |storage|
        storage.roots.map { |key| { key => storage[key] } }
      end
    end

    def secret_for(key)
      open_readonly do |storage|
        storage[key]
      end
    end

    def save(key, value)
      @storage.transaction do
        @storage[key] = value
      end
    end

    private

    def open_readonly
      @storage.transaction(true) do
        yield @storage
      end
    end
  end
end
