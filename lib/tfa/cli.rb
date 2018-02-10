require "thor"

module TFA
  class CLI < Thor
    package_name "TFA"
    class_option :filename
    class_option :directory

    desc "add NAME SECRET", "add a new secret to the database"
    def add(name, secret)
      secret = clean(secret)
      storage.save(name, secret)
      "Added #{name}"
    end

    desc "destroy NAME", "remove the secret associated with the name"
    def destroy(name)
      storage.delete(name)
    end

    desc "show NAME", "shows the secret for the given key"
    def show(name = nil)
      name ? storage.secret_for(name) : storage.all
    end

    desc "totp NAME", "generate a Time based One Time Password using the secret associated with the given NAME."
    def totp(name = nil)
      TotpCommand.new(storage).run(name)
    end

    desc "now SECRET", "generate a Time based One Time Password for the given secret"
    def now(secret)
      TotpCommand.new(storage).run('', secret)
    end

    desc "upgrade", "upgrade the pstore database to a yml database."
    def upgrade
      if !File.exist?(pstore_path)
        say_status :error, "Unable to detect #{pstore_path}"
        return ""
      end

      if yes? "Upgrade to #{yml_path}?"
        pstore_storage.each do |row|
          row.each do |name, secret|
            yaml_storage.save(name, secret) if yes?("Migrate `#{name}`?")
          end
        end
        if yes? "Delete `#{pstore_path}`?"
          File.delete(pstore_path)
        end
      end
      ""
    end

    private

    def storage
      File.exist?(pstore_path) ? pstore_storage : yaml_storage
    end

    def pstore_storage
      @pstore_storage ||= Storage.new(pstore_path)
    end

    def yaml_storage
      @yaml_storage ||= Storage.new(yml_path)
    end

    def filename
      options[:filename] || 'tfa'
    end

    def directory
      options[:directory] || Dir.home
    end

    def pstore_path
      File.join(directory, ".#{filename}.pstore")
    end

    def yml_path
      File.join(directory, ".#{filename}.yml")
    end

    def clean(secret)
      if secret.include?("=")
        /secret=([^&]*)/.match(secret).captures.first
      else
        secret
      end
    end
  end
end
