# Phenotype

ruby gem for versioning routes. Current supports Sinatra and other lightweight rack frameworks.

## Versioning an Application

Currently, versioning only supports blocks so you'll have to wrap your application like so.

- Version must be numeric
- Only one strategy is supported

```ruby
  app = Phenotype::VersionedApp.new(strategies: [Phenotype::HeaderStrategy.new])
  app.add_version(version: 1) do |env|
    MyApp::V1::App.call(env)
  end

  run app
```

**Note** for Sinatra apps you can create a cascading API using `use` in a Sinatra base

```ruby
class V2 < Sinatra::Base
  use V2Routes
  use V1Routes
end

app.add_version(version: 2) do |env|
  V2.call(env)
end
```

## Creating a Versioning Strategy

A strategy is a class that has two methods.

1. `get_version(env)` which takes a rack environment variable and returns a string of the version.

2. `version` which returns the version string. This is called after `get_version`

See the current provided examples in `lib/strategies`.
