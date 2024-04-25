# Weather App

## Dependencies
- Ruby (3.0.x)
- [Bundler (2.5.X)](https://bundler.io/)

Ruby can be install manually or with ruby version mananger like rbenv or rvm.
Use the following link to install rbenv

[Installing rbenv](https://github.com/rbenv/rbenv)

After rbenv and ruby(3.0.x) are installed (set the installed version of ruby to
your default version or local version before installing bundler), bundler needs
to be installed. It can be installed with the following

```
$ gem install bundler
```

## External dependencies

Accounts will need to created for the following in order to run the application

- [OpenWeatherAPI account](https://home.openweathermap.org/users/sign_up)
- [LocationIQ account](https://my.locationiq.com/register)

## Getting started

**All commands should be executed from the root directory of the project**

### Running the application

#### Configurations

Before starting the application you will need add configurations to a
`.env.development` file. The following steps will walk you through how to
configure the application.

First create the `.env.development` file

```bash
$ touch .env.development
```

Then add configurations for the following variables

```
WEATHER_API_KEY=<open_weather_api_key>
WEATHER_API_BASE_URL=https://api.openweathermap.org
GEO_LOCATION_API_KEY=<locationiq_api_key>
GEO_LOCATION_API_BASE_URL=https://us1.locationiq.com
```

#### Enabling caching

The weather/geo location API can be cached when running the application in
development by creating the `tmp/caching-dev.txt` file.

```
$ touch tmp/caching-dev.txt
```

#### Installing dependencies

To install the application dependencies

```
$ bundle install
```

#### Running the application

After environment has been setup (env config, caching, install dependencies),
start the application

```
$ bin/rails s
```

This will start the webserver on port 3000. Navigate to `http://localhost:3000`
in your favorite browser and start searching for your local forecast.

### Running the unit tests

To run the application specs

```
$ bundle exec rspec
```

## About application

Currently only US addresses are searchable and all weather values are using
imperial units.
