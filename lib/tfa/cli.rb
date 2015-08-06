require "thor"

module TFA
  class CLI < Thor
    package_name "TFA"
    class_option :filename

    desc "add NAME SECRET", "add a new secret to the database"
    def add(name, secret)
      storage.save(name, secret)
      "Added #{name}"
    end

    desc "show NAME", "shows the secret for the given key"
    def show(name = nil)
      name ? storage.secret_for(name) : storage.all
    end

    desc "totp NAME", "generate a Time based One Time Password"
    def totp(name = nil)
      TotpCommand.new(storage).run(name)
    end

    private

    def storage
      @storage ||= Storage.new(filename: options[:filename] || 'tfa')
    end
  end
end
