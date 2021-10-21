# WeSchedule
---
### Account Logins for seeded users
# Admin user
username = 'admin1@gmail.com'
password = 'password'

# Standard user
username = 'standard@gmail.com'
password = 'password'

# Premium user
username = 'premium@gmail.com'
password = 'password'



### How to install and run
Install rvm :- https://github.com/rvm/ubuntu_rvm
Run the following to install other dependancies:
rvm install 2.6.6
rvm use 2.6.6
gem install bundler
sudo apt-get install libsqlite3-dev
sudo apt-get install libpq-dev
bundle install

Set up DB:
rake db:create
rake db:migrate
rake db:seed

Run server:
bundle exec rails s

