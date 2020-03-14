# Aladtec
[![Gem Version](https://badge.fury.io/rb/aladtec.svg)](https://badge.fury.io/rb/aladtec)
[![Build Status](https://travis-ci.org/travisdahlke/aladtec.svg)](https://travis-ci.org/travisdahlke/aladtec)
[![Inline docs](http://inch-ci.org/github/travisdahlke/aladtec.svg?branch=master)](http://inch-ci.org/github/travisdahlke/aladtec)

A Ruby client library for the Aladtec FireManager API.

## Installation

Add this line to your application's Gemfile:

    gem 'aladtec'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aladtec

## Usage

Configure the gem with your credentials:

    Aladtec.configure do |config|
      config.client_id = ENV['ALADTEC_CLIENT_ID']
      config.client_secret = ENV['ALADTEC_CLIENT_SECRET']
      config.endpoint = ENV['ALADTEC_ENDPOINT']
    end

Get members

    client = Aladtec::Client.new
    client.members

Get events

    client.events(begin_time: Time.now, end_time: Time.now + 60 * 60 * 24)

Get schedules

    client.schedules

Get scheduled time ranges

    client.scheduled_range(begin_time: Time.new(2019,10,1), end_time: Time.new(2019,10,31))

Get members scheduled now

    client.scheduled_now

Refer to the [documentation](http://www.rubydoc.info/github/travisdahlke/aladtec) for more detailed usage.

## Contributing

1. Fork it ( http://github.com/travisdahlke/aladtec/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
