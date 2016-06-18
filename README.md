# ArraySearch

Allow Arrays to be searched using Active Record Syntax


Alternatives that may be better flushed out and fit your needs:

- active_hash
- passive_record, this

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'array_search'
```

## Usage

class User < Struct.new(:name, :state, :city, :state)
end

users = [User.new, User.new]

ArraySearch.wrap(users).where(:name => /Smith$/, :state => %w(MA NH)).to_a

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kbrock/array_search


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

