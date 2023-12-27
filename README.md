![tests](https://github.com/eebbesen/broadcast/actions/workflows/test_lint.yml/badge.svg)

See test GitHub Action run for code coverage percentage

# Broadcast
Send SMS to distinct groups of recipients. Allow numbers to subscribe to topics.

*under development, not fully functional*

## Twilio Configuration
To send messages the following environment variables will need to be set
```
TWILIO_SID
TWILIO_TOKEN
TWILIO_PHONE
```

# Developers
## Prerequisities
* Have a PostgreSQL instance available or modify the application to use another database
  * replace `pg` references in the Gemfile
  * update `config/database.yml`
* Have a Twilio account (if you will be sending messages to Twiliio)
  * Twilio accounts allow test accounts, which will allow you to interact with Twilio services but not actually send messages _or_ charge you per send

## Setup
```bash
bundle install
bin/rails db:create
```

Create an admin user via the Rails console
```ruby
Admin.create!(email: 'you@example.com', password: 'S3Kr1t!')
```

Create users via http://localhost:3000/users/sign_in or via the Rails console, then seed
```bash
bin/rails db:seed:replant
```

Run in watch mode with assets
```bash
bin/dev
```
or compile manually and use `rails server`
```bash
bin/rake assets:precompile
bin/rails s
```

## Tests
Both system and unit tests are present
```bash
bundle exec rspec
```

### Twilio
To reduce effort and prevent the sending of real SMS while testing, `rails_helper.rb` will set Twilio send values (`SID`, `TOKEN`, and `PHONE`) to test versions if you have them declared in your environment variables _unless_ you have the variables on the left already populated:

```
TWILIO_SID ||= ENV['TWILIO_TEST_SID']
TWILIO_TOKEN ||= ENV['TWILIO_TEST_TOKEN']
TWILIO_PHONE ||= '+15005550006'
```

See https://www.twilio.com/docs/iam/test-credentials for details. The `TWILIO_PHONE` when using test credentials needs to be one of a few specific numbers, which is why the value is hard-coded above.

### System Tests
#### Viewing rendered pages during system tests
When at a breakpoint, enter the following on the console
```bash
save_and_open_page
```

#### Headed Browser mode
Tests tha execute JavaScript will need to mark themselves as `js: true` (see spec/system/navbar_spec.rb for an example). Per RSpec configuration in spec_helper these run in headless mode by default. Tests _not_ marked as `js: true` will use `driven_by :rack_test`. Note that tests `rack_test` is significantly faster than `selenium_chrome` so only tests that need to interact with JavaScript should be run with the latter.

Should you desire to run in headed mode specify `driven_by :selenium_chrome` at the test level, block level, or by changing the config value in spec_helper.rb.

## Linters
```
bundle exec rubocop
bundle exec brakeman
bundle exec bundler-audit --update
bundle exec reek
```

# Production Deployment
## Render
* Create web application
* Create database instance
* Add secrets to web app
  * SECRET_KEY_BASE
  * BROADCAST_DATABASE_NAME
  * BROADCAST_DATABASE_HOST
  * BROADCAST_DATABASE_PASSWORD
  * BROADCAST_DATABASE_USERNAME
  * TWILIO_SID
  * TWILIO_TOKEN
  * TWILIO_PHONE
  * NEW_RELIC_LICENSE (if monitoring with New Relic)
* Connect to the database and run migrations
  * If on the free tier you'll have to do this from your local box


# A11y
This application uses the [axe](https://github.com/dequelabs/axe-core-gems) for accessibility checking

* https://dequeuniversity.com/rules/axe/4.8
* https://www.w3.org/WAI/ER/tools/
* https://webaim.org/resources/contrastchecker/

# Monitoring
## New Relic
You need to populate environment variable `NEW_RELIC_LICENSE`
### OSX
New Relic agent can run on OSX, but log integration doesn't seem to be available directly on OSX
```bash
brew services run newrelic-infra-agent # use 'start' instead of 'run' to always start the agent
brew services stop newrelic-infra-agent
```
https://docs.newrelic.com/docs/logs/forward-logs/forward-your-logs-using-infrastructure-agent/

# Docker
By default the app runs in production mode on Docker, but this implementation is not intended for production use due to security (e.g., exposed PostgreSQL password).

This requires a SECRET_KEY_BASE value and certs for SSL.

https://github.com/docker/awesome-compose/blob/master/official-documentation-samples/rails/README.md

## Certificates
Docker-compose will use these
```bash
mkdir -p config/credentials
cd config/credentials
mkcert localhost
mkcert -install
```

## Build the image
```bash
docker build -t broadcast .
```

## Connect to the rails console via the web container
```bash
docker exec -it broadcast-web-1 /bin/bash
bin/rails
```

## Run app and database using Docker compose
```bash
SECRET_KEY_BASE=$(cat config/master.key) docker compose up
```
