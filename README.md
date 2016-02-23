# Phenotype
ruby gem for versioning. Current supports Sinatra and other lightweight rack frameworks.

## Versioning an Application
Currently, versioning only supports blocks so you'll have to wrap your application like so.

```ruby
  app = Phenotype::VersionedApp.new(strategies: [Phenotype::HeaderStrategy.new, Phenotype::ParamStrategy.new])
  app.add_version(version: 'v1', default: true) do |env|
    MyApp::V1.new().call(env)
  end

  run app
  
```

Note that for Sinatra apps you can create a cascading API using `use` in a Sinatra base

```ruby
class V2 < Sinatra::Base
  use V2Routes
  use V1Routes
end

app.add_version(version: 'v2') do |env|
  V2.call(env)
end
```

## Creating a Versioning Strategy
A strategy is a class that has two methods.

1. `get_version(env)` which takes a rack environment variable and returns a string of the version.

2. `version` which returns the version string. This is called after `get_version`

See the current provided examples in `lib/strategies`.
