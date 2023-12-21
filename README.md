# Broadcast
Send SMS to distinct groups of recipients


# Developers
## Prerequisities
* Have a PostgreSQL instance available or modify the application to use another database
  * replace `pg` references in the Gemfile
  * update `config/database.yml`

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
bin/rake db:seed:replant
```

## Tests
Both system and unit tests are present
```bash
rspec
```

### System Tests
#### viewing rendered pages during system tests
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
bundle exec bundler-audit
bundle exec reek
```


Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
