# Capistrano::Devops

Capistrano::Devops gathers together some capistrano recipes to help in configuring and deploying applications

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano-devops', group: development

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-devops

## Usage

add in Capfile

    require 'capistrano/devops'

add in deploy.rb

    set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Development

There is a sample app in /sample_app that you can use to play around with the recipes. I personally use Vagrant and sandbox mode available at https://github.com/jedi4ever/sahara to create the VM for deployment.

Right now the Vagrantfile still needs a bit of work (mostly the post-install script that will provision the server with ruby, bundler, and nginx)
