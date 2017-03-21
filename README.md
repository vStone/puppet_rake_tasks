# PuppetModuleTask

TODO: Delete this and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'puppet_rake_tasks'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install puppet_rake_tasks

## Usage

### Simple usage:

1. Add the ruby gem: `gem 'puppet_rake_tasks'`
2. Require the depchecker in your `Rakefile`: `require 'puppet_rake_tasks/depchecker'`
3. Create the task: `PuppetRakeTasks::DepChecker::Task.new`
4. Profit: `rake exec depcheck

### Advanced usage:

Optionally, you can also configure the task:

```ruby
require 'puppet_rake_tasks/depchecker'
PuppetRakeTasks::DepChecker::Task.new do |checker|
  checker.fail_on_error = true
  checker.modulepath = [
    'site',
    'modules'
  ]
  checker.ignore /.*/, { name: 'foo/bar', reason: :missing }
end
```

## Development

After checking out the repo, run `bundler install` to install dependencies. Then, run `bundle exec rake spec` to run the tests. You can also run `bundle console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/vStone/puppet_rake_tasks).

## License

The gem is available as open source under the terms of the [GPL-3 License](http://opensource.org/licenses/GPL-3.0).

