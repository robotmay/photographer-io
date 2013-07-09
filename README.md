# Photographer.io

* [Photographer.io](https://www.photographer.io) is a photo sharing community.
* Created by Robert May, Afternoon Robot Ltd.
* Twitter: [@robotmay](https://twitter.com/robotmay) and [@photographer_io](https://twitter.com/photographer_io).
* IRC: [#photographer-io on Freenode](irc://chat.freenode.net/photographer-io)

## This readme is in progress
If you have any questions don't hesitate to ask via Twitter or at <support@photographer.io>

## Platform
### Languages Used
* Ruby
* CoffeeScript
* SASS

### Notable Libraries
* Rails 4.0

### Server Platform
* Ruby 2.0
* PostgreSQL 9+
* Redis
* Memcached
* Solr

### External Services
* Amazon S3 and CloudFront

## Status
[![Build Status](https://www.travis-ci.org/afternoonrobot/photographer-io.png?branch=master)](https://www.travis-ci.org/afternoonrobot/photographer-io)
[![Coverage Status](https://coveralls.io/repos/afternoonrobot/photographer-io/badge.png)](https://coveralls.io/r/afternoonrobot/photographer-io)
[![Code Climate](https://codeclimate.com/github/afternoonrobot/photographer-io.png)](https://codeclimate.com/github/afternoonrobot/photographer-io)

## Translations
There is now an [active translation project](https://www.transifex.com/projects/p/photographerio/) on [Transifex](https://www.transifex.com). Come along and contribute to localising this app for your language, or start up a new translation if it doesn't exist. Support for actually switching the language on Photographer.io is planned for a milestone in the next month.

The default is technically British English, which I feel I should point out before anyone goes switching all the 's' to 'z'!

## Development
To run this app you'll likely need a rough understanding of how Rails apps work these days. You will also need:

* Postgresql 9.2+ (it uses a number of DB specific features)
* Redis
* Memcached (actually still used in the dev environment, though that may change)
* Solr (if you want search, otherwise it's safe-ish to ignore for now)
* Ruby 2.0.0 (untested on anything lower, might be fine on 1.9.3)

First, clone the repo (ideally from your own fork):

`git clone git@github.com:afternoonrobot/photographer-io.git`

Then move into that directory install the gems using Bundler:

`bundle install`

Now you'll need to create a database.yml file as this isn't checked in to the repo. 
There's a template you can copy across for the default settings:

`cp config/database.example.yml config/database.yml`

You'll likely need to edit those settings for your local machine.
Now you need to create and set up the database:

`rake db:setup`

This will automatically set up some base data (licenses and categories).

The app depends heavily on environment variables for API keys and the like. 
There are two example .env files in the repo; .env.example, and .env.full_example. 
I believe .env.example to be the minimum required settings, though this is likely open to experimentation
and could definitely use improvements.

Copy one of those files to .env and populate it:

`cp .env.example .env`

In theory the app will work without S3 enabled, let me know if this isn't the case.

Now start it up with Foreman:

`foreman start`

This should start up both the web process and the worker process.
To start up the automated testing you might first need to create and migrate the test DB:

```
RAILS_ENV=test rake db:create
RAILS_ENV=test rake db:migrate
```

Then you can start up the automated tests with Guard:

`bundle exec guard`

Or manually with:

`rake spec`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
