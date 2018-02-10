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
      pstore_path = File.join(directory, ".#{filename}.pstore")
      yml_path = File.join(directory, ".#{filename}.yml")

      if !File.exist?(pstore_path)
        say "Unable to detect #{pstore_path}"
        return ""
      end

      say "Detected #{pstore_path}"
      case ask "Would you like to upgrade to #{yml_path}", limited_to: ["yes", "no"]
      when "yes"
        say "Let's begin..."
        pstore_storage = Storage.new(pstore_path)
        yaml_storage = Storage.new(yml_path)
        pstore_storage.each do |row|
          row.each do |name, secret|
            case ask "Would you like to migrate `#{name}`?", limited_to: ["yes", "no"]
            when "yes"
              say "Migrating `#{name}`..."
              yaml_storage.save(name, secret)
            end
          end
        end
        case ask "Would you like to delete `#{pstore_path}`? (this action cannot be undone.)", limited_to: ["yes", "no"]
        when "yes"
          File.delete(pstore_path)
        end
      else
        say "Nothing to do. Goodbye!"
      end
      ""
    end

    private

    def storage
      @storage ||= Storage.new(File.exist?(pstore_path) ? pstore_path : yml_path)
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
