# Born

Born helps organising birthdays and gifts for team mates.

## Requirements
- Ruby 2.2.0
- PostgreSQL
- NodeJS
- OpenSSL
- Redis (for Sidekiq)


## Local setup


```bash
# 1. set ruby's version, e.g. $ rbenv local 2.2.0

# 2. run setup script and follow its instructions
bin/setup

# 3. create and migrate database 
bundle exec rake db:create db:migrate
# 4. run seeds
rake db:seed

# 5. install foreman
gem install foreman

# 6. start the app
foreman start
```
