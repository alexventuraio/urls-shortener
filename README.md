# Urls Shortener

To setup the application in your local machine you need to have `ruby 2.6.3` and `rails 5.2.3` installed. Then follow the next steps:
1. First clone the repository:
	```sh
	git clone git@github.com:alexventuraio/urls-shortener.git
	```
2. Then, enter into the main directory:
	```sh
	cd urls-shortener/
	```
3. Now run `bundle install`
4. The database is handled by PostgreSQL, we recommend you to install it first. Then copy the sample DB configuration file:
	```sh
	cp config/database.yml.sample config/database.yml
	```
5. Now you are ready to create the database and run the migrations by executing:
	```sh
	rake db:create && rake db:migrate
	```
6. Now you are ready to run the **Rails** server with:
	```sh
	rails s
	```
7. Finally, open your browser and go to:
	```sh
	[http://localhost:3000](http://localhost:3000/)
	```

## How to run the test suite

We are using **Rspec** for the entire tests suite, so you can run them by executing:
```sh
bundle exec rspec
```
To run a specific file just add the name file like this:
```sh
bundle exec rspec spec/models/url_spec.rb
```
Also, make sure to set up the ENV variable for the Redis local server. Copy the sample configuration file:
```sh
cp .env.sample .env
```
And set the corresponding value in there:
```rb
REDIS_PROVIDER=redis://localhost:6379/0
```
## How to run Job Services
We are handling background processing with [Sidekiq](https://sidekiq.org) and [Redis](https://redis.io) but for development purpose in local environment we are are running jobs inline as you can see in the following config:
```rb
# config/application.rb
config.active_job.queue_adapter = Rails.env.production? ? :sidekiq : :async
```
So, if you want to run jobs in Sidekiq, then you only need to change the `queue_adapter` to `:async` and make sure you have **Redis** running and you should be ready to go.

## The live app is at

https://myshorten.herokuapp.com/

## The algorithm to shorten URL
We are taking advantage of the already existing [Digest Class](https://ruby-doc.org/stdlib-2.4.0/libdoc/digest/rdoc/Digest/SHA2.html) in Ruby language.

This class allow us to generate a hash from a given string as described in the documentation and accepts a second param to indicate the number of caracters we want to get back. So, we are taking only the first 10 characters to make it kind of short. The most commonly used class method is `hexdigest` and this is the one we are using, but there are also `digest` and `base64digest`.

Basically, this is the way we are generating the shorten URLs.
