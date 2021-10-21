# WeSchedule
---
# Account Logins for seeded users
### Admin user
username = 'admin1@gmail.com'
password = 'password'

### Standard user
username = 'standard@gmail.com'
password = 'password'

### Premium user
username = 'premium@gmail.com'
password = 'password'



# How to Install and Run
### Install Dependancies
Install rvm :- https://github.com/rvm/ubuntu_rvm
rvm install 2.6.6
rvm use 2.6.6
gem install bundler
sudo apt-get install libsqlite3-dev
sudo apt-get install libpq-dev
bundle install

### Set Up DB
rake db:create
rake db:migrate
rake db:seed

### Run Server
Run server:
bundle exec rails s

