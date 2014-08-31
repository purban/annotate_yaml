# AnnotateYaml [![Code Climate](https://codeclimate.com/github/purban/annotate_yaml/badges/gpa.svg)](https://codeclimate.com/github/purban/annotate_yaml)

Have you never been bored to scroll up an entire YAML structure to find out how to access the value?

Fear no more, here is this marvellous gem which add comment to each value of your YAML files so you can easily use it in your views or wherever you may need it.

## Quick Exemple

Let's say you want to use the quadrillion value of this file, what is its key?

    en:
      number:
        format:
          delimiter: ! ','
          precision: 3
          separator: .
          significant: false
          strip_insignificant_zeros: false
        [...]
        human:
          decimal_units:
            format: ! '%n %u'
            units:
              billion: Billion
              million: Million
              quadrillion: Quadrillion
              thousand: Thousand
              trillion: Trillion
              unit: ''

With annotate_yaml your YAML file will look like this:

    en:
      number:
        format:
          delimiter: ! ',' # en.number.format.delimiter
          precision: 3 # en.number.format.precision
          separator: . # en.number.format.separator
          significant: false # en.number.format.significant
          strip_insignificant_zeros: false # en.number.format.strip_insignificant_zeros
        [...]
        human:
          decimal_units:
            format: ! '%n %u' # en.number.human.decimal_units.format
            units:
              billion: Billion # en.number.human.decimal_units.units.billion
              million: Million # en.number.human.decimal_units.units.million
              quadrillion: Quadrillion # en.number.human.decimal_units.units.quadrillion
              thousand: Thousand # en.number.human.decimal_units.units.thousand
              trillion: Trillion # en.number.human.decimal_units.units.trillion
              unit: '' # en.number.human.decimal_units.units.unit

Now you know the key is `number.human.decimal_units.units.quadrillion`, thanks annotate_yaml!

## Installation

Add this line to your application's Gemfile:

    gem 'annotate_yaml'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install annotate_yaml

## Usage

To annotate your locales run:

`rake annotate:yaml:locales`

This will add a commented key to access each value of the YAML file.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/annotate_yaml/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
