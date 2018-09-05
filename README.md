# Sidekiq::Cron::Tasks

[![Build Status](https://travis-ci.org/coverhound/sidekiq-cron-tasks.svg?branch=master)](https://travis-ci.org/coverhound/sidekiq-cron-tasks)

Adds `rake` and `cap` tasks for loading `Sidekiq::Cron::Job`s from a config
file.

## Usage

#### Rake task

You can run the rake task via:

```sh
bundle exec rake sidekiq_cron:load
```

It expects a configuration file at `config/sidekiq_cron.yml` in this format:

```yml
default: &defaults
  rake task does stuff:
    cron: "42 0 * * *"
    class: "RakeTaskJob"
    args:
      - does:stuff

development:
  <<: *defaults

staging:
  <<: *defaults

production:
  <<: *defaults
```

You can configure the location of this file, as well as name prefixes for tasks:

```rb
Sidekiq::Cron::Tasks.configure do |config|
  config.file = "/custom/file/path"
  config.prefix = "notmyprefix"
end
```

#### Capistrano

You can enable this task for Capistrano deployment. It runs around the same time
that Rails' db migrations do. To enable it:

```rb
# Capfile
require 'capistrano/sidekiq-cron'
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'sidekiq-cron-tasks'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install sidekiq-cron-tasks
```

## Usage Outside of Rails

You MUST add configuration settings for `file` and `env`, e.g.

```ruby
Sidekiq::Cron::Tasks.configure do |config|
  config.file = "config/sidekiq_cron.yml"
  config.env  = ENV['RACK_ENV'] # this just defines the key to look up in the YAML file
end
```

Append the following to your `Rakefile` to add the `sidekiq_cron:load` rake task:

```ruby
require 'sidekiq-cron-tasks'
spec = Gem::Specification.find_by_name 'sidekiq-cron-tasks'
Dir.glob("#{spec.gem_dir}/lib/tasks/sidekiq_cron/*.rake").each { |r| import r }
```

Optionally, define an `:environment` task to load ENV vars, run initializers, etc. This task will be run before
`sidekiq_cron:load`.

```ruby
task :environment do
  require 'config/boot.rb'
end
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
