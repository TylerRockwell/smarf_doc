# SmarfDoc

(Formerly 'DocYoSelf')

![Smarf](http://i.imgur.com/f5mzeRU.png)

Too many docs spoil the broth.

SmarfDoc lets you turn your controller tests into API docs _without making changes to your test suite or how you write tests_.

Pop it into your test suite and watch it amaze.

Time for this project was provided by my employer, [SmashingBoxes](http://smashingboxes.com/). What a great place to work!

## Setup

In your gemfile:
`gem 'smarf_doc', group: :test, github: 'RickCarlino/smarf_doc'`

In  `test_helper.rb`:
```ruby
SmarfDoc.config do |c|
  c.template_file = 'test/template.md.erb'
  c.output_file   = 'api_docs.md'
end
```

[See test/fake_template.md for template examples.](https://github.com/RickCarlino/smarf_doc/blob/master/test/fake_template.md)

To run doc generation after every controller spec, put this into your `teardown` method. Or whatever method your test framework of choice will run after *every test*.

## Minitest Usage

Create your smarf by putting the creation in setup
```ruby
class ActionController::TestCase < ActiveSupport::TestCase
  def setup
    @smarf = SmarfDoc.new
  end
end
```

Running it for every test case:

```ruby
class ActionController::TestCase < ActiveSupport::TestCase
  def teardown
    @smarf.run!(request, response)
  end
end
```

..or if you only want to run it on certain tests, try this:

```ruby
def test_some_api
  get :index, :users
  assert response.status == 200
  @smarf.run!(request, response)
end
```

Then put this at the bottom of your `test_helper.rb`:

```ruby
MiniTest::Unit.after_tests { @smarf.finish! }
```

## Rspec Usage

Put this in your `spec_helper` and smoke it.

```ruby
RSpec.configure do |config|
  config.after(:each, type: :controller) do
    SmarfDoc.run!(request, response)
  end

  config.after(:suite) { @smarf.finish! }
end
```


## Usage

It will log all requests and responses by default, but you can add some **optional** parameters as well.

### Skipping documentation

To skip a single test, use `@smarf.skip`

```ruby
def test_stuff
  @smarf.skip
  # Won't generate docs for this test
end
```

To skip all tests, use `@smarf.skip_all`

```ruby
def test_stuff
  @smarf.skip_all
  # Won't generate docs for any tests
end
```

To skip all tests except certain ones, use skip_all above, then add `@smarf.run_this_anyway` to the tests you want to run

```ruby
def test_stuff
  @smarf.run_this_anyway
  # Generates docs for this test even if you used skip_all
end
```


## Adding notes or other information

You can add notes or any other type of information to the tests
by sending a key and value to `@smarf.information`.

```ruby
def test_stuff
  @smarf.information(:note, "This test is awesome")
  # More test stuff
end
```
