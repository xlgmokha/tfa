# two factor authentication

[![Build Status](https://travis-ci.org/mokhan/tfa.svg?branch=v0.0.2)](https://travis-ci.org/mokhan/tfa)
[![Code Climate](https://codeclimate.com/github/mokhan/tfa.png)](https://codeclimate.com/github/mokhan/tfa)

This CLI helps to manage your one time passwords for different accounts/environments.
The goal of this tool is to help you generate one time passwords quickly
from the command line that you can pipe into your clipboard. This saves
you from having to pull out your phone and cracking open the Google
Authenticator app to generate a one time password.

In order to use this software you will need access to the secret
embedded in the provisioning uri used to set up your two factor
authentication account. This usually comes in the form of a QR Code 
and might look like:

```ruby
  'otpauth://totp/alice@google.com?secret=JBSWY3DPEHPK3PXP'
```

## Installation

    $ gem install tfa

## Usage

To add a secret you can use the add command. The key you use can be
anything you choose. In the example below the key is development.

```shell
  $ tfa add development <secret>
```

To display the secret associated with a key:

```shell
  $ tfa show development
```

To generate a time based one time password for a specific key.

```shell
  $ tfa totp development
  $ 260182
```

You can also pipe it to your clipboard.

```shell
  $ tfa totp development | pbcopy
```

or

```shell
  $ tfa totp development | xclip -selection clipboard
```

## Contributing

1. Fork it ( https://github.com/mokhan/tfa/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
