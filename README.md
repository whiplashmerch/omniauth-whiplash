# Omniauth::Whiplash

Whiplash OAuth2 Strategy for OmniAuth.

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

`OmniAuth::Strategies::Whiplash` is simply a Rack middleware. Read the `omniauth-oauth2` docs for detailed instructions.

Here's a quick example, adding the middleware to a Rails app in config/initializers/omniauth.rb:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :whiplash, ENV.fetch('WHIPLASH_CLIENT_ID'), ENV.fetch('WHIPLASH_CLIENT_SECRET'), scope: ENV.fetch('WHIPLASH_CLIENT_SCOPE'), client_options: {site: ENV.fetch('WHIPLASH_API_URL')}
end
```

If you are using Devise, you can skip the above and instead include this to your Devise configuration in `initializers/devise.rb`:

```ruby
config.omniauth :whiplash, ENV.fetch('WHIPLASH_CLIENT_ID'), ENV.fetch('WHIPLASH_CLIENT_SECRET'), scope: ENV.fetch('WHIPLASH_CLIENT_SCOPE'), client_options: {site: ENV.fetch('WHIPLASH_API_URL')}
```

Please refer to the Whiplash API documentation for information regarding scopes.

## Single Sign-On (SSO)

There are a few steps to follow to get SSO configured via Oauth2. The solution below uses Devise. You don't have to use Devise, but it provides some of the OAuth2 legwork and so that is what we recommend.

*Note:* User accounts that are admin-level on Whiplash will automatically authorize your application. That means admins redirected to Whiplash for authentication will be immediately redirected back to your application if the permissions were configured correctly.

### 1. Configure your application for Devise

Add to your `Gemfile`:

```ruby
gem 'devise', '~> 4.3.0'
```

Install Devise:

```
rails generate devise:install
```

Create a `User` model:

```
rails generate devise User
```

### 2. Modify the user migration

You can remove some default Devise columns as we will not be using a standard Devise configuration.

Here is a sample migration that includes all the fields returned by the Whiplash OAuth endpoint:

```ruby
class DeviseCreateUsers < ActiveRecord::Migration[5.1]
  def change
    enable_extension("citext")

    create_table :users do |t|
      t.citext :email,              null: false, default: ""

      t.string :provider
      t.string :uid
      t.string :first_name
      t.string :last_name
      t.string :role
      t.string :whiplash_id

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
  end
end
```

*Please Note:* We are using the case-insensitive Postgres column type (`citext`) here. If you are using MySQL, you will want to switch this to `string` as that defaults to case-insensitive.

### 3. Setup the User Model

You can add any additional validations or methods as per usual to the `User` model. This is just the base setup to get SSO working.

```ruby
class User < ApplicationRecord

  devise :omniauthable, omniauth_providers: [:whiplash]

  def self.from_omniauth(omniauth_params)
    User.find_or_create_by(email: omniauth_params.info['email']) do |u|
      u.first_name  = omniauth_params.info['first_name']
      u.last_name   = omniauth_params.info['last_name']
      u.whiplash_id = omniauth_params.info['id']
      u.role        = omniauth_params.info['role']
    end
  end

end
```

The `self.from_omniauth` method is called automatically when a user is signing in. It will create a `User` record for new users and return existing users for previously created ones.

### 4. Setup the OmniAuth Endpoint

Create the controller in `controllers/users/omniauth_callbacks_controller.rb`:

```ruby
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  skip_before_action :require_user

  def whiplash
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect(@user, event: :authentication)
    end
  end

  def failure
    redirect_to root_path
  end

end
```

*Please Note:* We have a `before_action` defined here called `require_user`. We have that defined in `ApplicationController` like so:

```ruby
def require_user
  unless current_user
    redirect_to user_whiplash_omniauth_authorize_path
  end
end
```

Any controller you would like to place behind the SSO login, you can add the respective `before_action :require_user`.

Lastly, create the route in `routes.rb`

```ruby
devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
```

### 5. There is no step 5!

You are done. Just make sure you have set the environment variables and Devise configuration degined in the Usage section.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec omniauth-whiplash` to use the gem in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/whiplashmerch/omniauth-whiplash.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
