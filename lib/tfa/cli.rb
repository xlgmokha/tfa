require "thor"

module TFA
  class CLI < Thor
    package_name "TFA"
    class_option :filename

    desc "add NAME SECRET", "add a new secret to the database"
    def add(name, secret)
      AddCommand.new(storage).run([name, secret])
    end

    desc "show NAME", "shows the secret for the given key"
    def show(name = nil)
      ShowCommand.new(storage).run([name].compact)
    end

    desc "totp NAME", "generate a Time based One Time Password"
    def totp(name)
      TotpCommand.new(storage).run([name])
    end

    private

    def storage
      @storage ||= Storage.new(filename: options[:filename] || 'tfa')
    end
  end
end
