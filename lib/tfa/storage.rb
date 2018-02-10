module TFA
  class Storage
    include Enumerable

    def initialize(path)
      @storage =
        if ".pstore" == File.extname(path)
          PStore.new(path)
        else
          YAML::Store.new(path)
        end
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
