# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.6.6'
git_source(:github) { |repo_name| "https://github.com/#{repo_name}.git" }
git_source(:gitlab) { |repo_name| "git@git.shefcompsci.org.uk:#{repo_name}.git" }

gem 'airbrake', github: 'epigenesys/airbrake', branch: 'airbrake-v4'
gem 'epi_js'
gem 'rubycas-client', gitlab: 'gems/rubycas-client'

gem 'activerecord-session_store'
gem 'bootsnap'
gem 'rails', '6.0.3.7'
gem 'responders'
gem 'thin'

gem 'pg'

gem 'coffee-rails'
gem 'haml-rails'
gem 'sassc'
gem 'sassc-rails'
gem 'uglifier'

gem 'chartkick'
gem 'groupdate'

gem 'fullcalendar-rails'
gem 'momentjs-rails'


gem 'bootstrap'
gem 'font-awesome-sass'
gem 'jquery-rails'
gem 'jquery-ui-rails'
# select2-rails is vendored under vendor/assets

gem 'draper'
gem 'ransack'
gem 'simple_form'

gem 'bootstrap-will_paginate'
gem 'will_paginate'

gem 'cancancan'
gem 'devise'
gem 'devise_cas_authenticatable'
gem 'devise_ldap_authenticatable'

gem 'daemons', '1.1.9'
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'delayed-plugins-airbrake'
gem 'whenever'

gem 'bcrypt_pbkdf'
gem 'ed25519'
gem 'geocoder'

group :development, :test do
  gem 'byebug'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'sqlite3'
end

group :development do
  gem 'epi_deploy', github: 'epigenesys/epi_deploy'

  gem 'listen'
  gem 'web-console'

  gem 'capistrano'
  gem 'capistrano-bundler', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false

  gem 'annotate'
  gem 'eventmachine'
  gem 'letter_opener'
end

group :test do
  gem 'capybara'
  gem 'capybara-select2', github: 'goodwill/capybara-select2'
  gem 'capybara-selenium'
  gem 'factory_bot_rails'
  gem 'rspec-instafail', require: false
  gem 'shoulda-matchers'
  gem 'webdrivers'

  gem 'database_cleaner'
  gem 'launchy'
  gem 'simplecov'
end

gem "rspec-benchmark", "~> 0.6.0"

gem "bullet", "~> 6.1"

gem "slack-notifier", "~> 2.3"
