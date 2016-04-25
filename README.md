# Omniauth::Whiplash

Whiplash OAuth2 Strategy for OmniAuth 1.0.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-whiplash'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-whiplash

## Usage

`OmniAuth::Strategies::Whiplash` is simply a Rack middleware. Read the OmniAuth 1.0 docs for detailed instructions.

Here's a quick example, adding the middleware to a Rails app in config/initializers/omniauth.rb:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :whiplash, ENV['WHILASH_CLIENT_ID'], ENV['WHIPLASH_CLIENT_SECRET']
end
```

## Configuration

You can configure the scope, which you pass in to the provider method via a Hash:

`scope`: A comma-separated list of permissions you want to request from the user. See the Shopify API docs for a full list of available permissions.
For example, to request read_products, read_orders and write_content permissions and display the authentication page:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :whiplash, ENV['WHILASH_CLIENT_ID'], ENV['WHIPLASH_CLIENT_SECRET'], scope: 'read_orders write_orders read_items write_items read_web_hooks write_web_hooks read_customers read_user'
end
```

NOTE: The default scope is `read_user` and is required as part of the `scope` argument, if it's passed in.

ALSO: The scope arguments should be passed in *separated by spaces, not commas*, as per above.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec omniauth-whiplash` to use the gem in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/whiplashmerch/omniauth-whiplash.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
