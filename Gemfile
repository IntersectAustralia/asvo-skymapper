source 'https://rubygems.org'

gem 'rails', '~> 3.2.19'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'
gem "create_deployment_record", git: 'https://github.com/IntersectAustralia/create_deployment_record.git'
gem 'uglifier', '>= 1.0.3'
# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'haml_coffee_assets'
  gem 'execjs'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

gem "therubyracer" # TODO should this be in group :assets ?
group :development, :test do
  gem "rspec-rails"
  gem "factory_girl_rails"

  # cucumber gems
  gem "cucumber"
  gem "capybara"
  gem "database_cleaner"
  #gem "spork"
  gem "launchy"    # So you can do Then show me the page
  gem "zeus"
  gem "mailcatcher"
  gem "poltergeist"
  gem "teaspoon"
  gem 'better_errors'
  gem 'binding_of_caller'
  gem "xray-rails"
  gem "pry-rails"
end

group :test do
  gem "cucumber-rails", :require => false
  gem "shoulda"
  gem "brakeman"
  gem "simplecov", ">=0.3.8", :require => false
  gem "simplecov-rcov"
  gem "selenium-webdriver"
  gem "fakeweb"
end

gem "haml"
gem "haml-rails"
gem "bootstrap-sass"
gem "simple_form"
gem "devise"
gem "email_spec", :group => :test
gem "cancan"
gem "capistrano-ext"
gem "capistrano"
gem "capistrano_colors"
gem "rvm-capistrano"
gem "colorize"
gem "nokogiri"
gem "unicorn"
gem 'whenever', :require => false
gem 'google-analytics-rails'
