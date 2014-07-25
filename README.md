# In

[![Build Status](https://travis-ci.org/mokhan/tfa.svg?branch=v0.0.2)](https://travis-ci.org/mokhan/tfa)

Create a one time password for your different environments.


## Installation

Add this line to your application's Gemfile:

    gem 'tfa'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tfa

## Usage


```shell
  $ tfa add 
  $ tfa add develoment <secret>
  $ tfa show development
  $ tfa totp development
```

## Contributing

1. Fork it ( https://github.com/mokhan/tfa/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
