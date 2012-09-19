# gnip-rule [![Build Status](https://secure.travis-ci.org/eriwen/gnip-rule.png)](http://travis-ci.org/eriwen/gnip-rule)
Ruby library for working with the Gnip Rules API

## Installation
Add the following to your `Gemfile`:

```ruby
gem 'gnip-rule', '~> 0.1.1'
```

## Example

```ruby
require 'gnip-rule'

ruler = GnipRule::Client.new(GNIP_API_URL, GNIP_USERNAME, GNIP_PASSWORD)

# Add as a String, Rule, or Array of either
ruler.add('foo')
ruler.add('bar', 'tag')
ruler.add(['foo', 'bar', 'baz'], 'tag')
ruler.add(GnipRule::Rule.new('value', 'tag'))
ruler.add([GnipRule::Rule.new('value', 'tag'), ruler.add(GnipRule::Rule.new('othervalue', 'othertag'))])

# Same with delete
ruler.delete('baz', 'tag')
ruler.delete(['foo', 'bar'])
ruler.delete(GnipRule::Rule.new('value', 'tag'))

# Get all ruler as Rule objects
ruler.list()
```

## License
MIT License: http://www.opensource.org/licenses/mit-license.php
