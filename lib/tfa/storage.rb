module TFA
  class Storage
    def initialize(filename:)
      @storage = PStore.new(File.join(Dir.home, ".#{filename}.pstore"))
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
