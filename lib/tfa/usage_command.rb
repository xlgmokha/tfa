module TFA
  class UsageCommand
    def initialize(storage)
    end

    def run(arguments)
      <<-MESSAGE
Try:
  - tfa add develoment <secret>
  - tfa show development
  - tfa totp development
      MESSAGE
    end
  end
end
