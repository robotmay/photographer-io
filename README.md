# Photographer.io

* Photographer.io is an open-source photo sharing community, no longer in production.
* Created by Robert May.
* Twitter: [@robotmay](https://twitter.com/robotmay)

## No Longer Supported
I ceased operating Photographer.io last year but the repo remains here for use by others or for reference. You are welcome to ask questions but my time for providing any support is limited these days, and the repo is likely quite out of date.

Thanks to everyone who contributed and used Photographer.io.

Rob

## Platform
### Languages Used
* [Ruby](http://www.ruby-lang.org)
* [CoffeeScript](http://coffeescript.org)
* [SASS](http://sass-lang.com)
* [Slim](http://slim-lang.com)

### Notable Libraries
* [Rails 4.0](http://rubyonrails.org)

### Server Platform
* Ruby 2.0
* PostgreSQL 9+
* Redis
* Memcached
* Solr

### External Services
* Amazon S3 and CloudFront

## Status
[![Build Status](https://travis-ci.org/afternoonrobot/photographer-io.png?branch=master)](https://travis-ci.org/afternoonrobot/photographer-io)
[![Coverage Status](https://coveralls.io/repos/afternoonrobot/photographer-io/badge.png)](https://coveralls.io/r/afternoonrobot/photographer-io)
[![Code Climate](https://codeclimate.com/github/afternoonrobot/photographer-io.png)](https://codeclimate.com/github/afternoonrobot/photographer-io)

## Translations
There is now an [active translation project](https://www.transifex.com/projects/p/photographerio/) on [Transifex](https://www.transifex.com). Come along and contribute to localising this app for your language, or start up a new translation if it doesn't exist. 

The default is technically British English, which I feel I should point out before anyone goes switching all the 's' to 'z'!

## Development
To run this app you'll likely need a rough understanding of how Rails apps work these days. You will also need:

* Postgresql 9.2+ (it uses a number of DB specific features), with uuid-ossp extension
* Redis
* Memcached
* Solr (if you want search, otherwise it's safe-ish to ignore for now)
* MRI Ruby 2.0.0 (untested on anything lower, might be fine on 1.9.3)
  * It currently does __not__ run on JRuby. A port was attempted a few weeks back and it's not especially straight-forward, but it would be nice to support it in future.

First, clone the repo (ideally from your own fork):

`git clone git@github.com:afternoonrobot/photographer-io.git`

Then move into that directory install the gems using Bundler:

`bundle install`

Now you'll need to create a database.yml file as this isn't checked in to the repo. 
There's a template you can copy across for the default settings:

`cp config/database.example.yml config/database.yml`

You'll likely need to edit those settings for your local machine.
> In particular, you may want to check your username in psql with command: `$ psql` which should bring up your psql command line `username=#`. You can update your `config/database.yml` accordingly. Also,you may [create new PG database](http://www.postgresql.org/docs/9.0/static/sql-createdatabase.html).

Now you need to create and set up the database:

`rake db:setup`

This will automatically set up some base data (licenses and categories).

The app depends heavily on environment variables for API keys and the like. 
There are two example .env files in the repo; .env.example, and .env.full_example. 
I believe .env.example to be the minimum required settings, though this is likely open to experimentation
and could definitely use improvements.

Copy one of those files to .env and populate it:

`cp .env.example .env`

##### S3 is used in development
Due to the plugins used for handling uploads, S3 support is required even in development. It's not ideal, but you'll need to fill out those S3 keys in your .env file with details for your S3 bucket.

In both development and production you will need to configure CORS correctly on Amazon. [See the README in the upload script we use for more details](https://github.com/waynehoover/s3_direct_upload).

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

## Production

Instructions for running in production will be coming soon. It does run on Heroku, and you might be able to get it going with little more than the instructions above.
If you do decide to host your own version of the app; great! My only request is that you switch out the branding (Photographer.io) to your own name, just to ease confusion.

I'd like to make it easier for people to maintain their own forks of the app whilst still being able to receive upstream features and bugfixes. To aid this I'll be revising a lot of the existing configuration to give you more options.

## Contributing

1. Fork it
2. Add upstream - in this case to author (`git remote add upstream git@github.com:afternoonrobot/photographer-io.git`)
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
