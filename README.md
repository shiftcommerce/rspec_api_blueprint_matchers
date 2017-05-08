# RspecApib

This gem allows your rspec test suite to validate requests and responses against
your api blueprint documentation.

It also allows for validating that all documented http transactions are
covered in your test suite.  (Care should be taken with parallel specs if using this)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec_apib', group: :test
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec_apib

## Usage

For the rest of the documentation, we will refer to "request" and "response".  These
can be a faraday request / response environment, or a rack request / response environment
or a generic request / response from a rails integration test suite.

### Validating a http transaction

A transaction is a struct containing "request" and "response" where request and
response are typical requests and responses from rack / faraday etc..
At present, we are using this gem for faraday though.

```ruby
expect(transaction).to match_api_docs_for(path: "/blogs", request_method: :post, content_type: "application/json")
```

#### How This Works

How this works is the request is repeatedly matched against all transactions
(request / response pairs) in the api blueprint document.  This is done in
2 phases - first a 'short list', then a detailed match on this short list.
This is to prevent expensive schema matching when even the basics don't match.
The short list is then further filtered by what the developer asked for in the
'match_api_docs_for' matcher.

The matcher also allows the symbol :any to mean "Don't care what it is" but use
with caution.

The same is then done for the response and any transactions that match both
are considered a good match.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rspec_apib.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
