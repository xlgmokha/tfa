module TFA
  class Storage
    include Enumerable

    def initialize(options)
      partial_path = File.join(Dir.home, ".#{options[:filename]}")
      @storage = PStore.new("#{partial_path}.pstore")
    end

    def each
      all.each do |each|
        yield each
      end
    end

    def all
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

    def delete(key)
      @storage.transaction do
        @storage.delete(key)
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
