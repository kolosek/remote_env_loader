Remote Env Loader
==============

Installation
-----------------

  Add to Gemfile:
  
  ```
  gem 'remote_env_loader', git: 'https://github.com/kolosek/remote_env_loader.git', tag: 'v0.0.3'
  ```

  Pin to a release tag so updates are picked up deliberately. To upgrade, change the tag and run `bundle update remote_env_loader`.

  The gem registers a Railtie that loads the environment automatically when the application class is defined (`before_configuration`). This runs **after** `Bundler.require`, so if any gem reads remote ENV variables while it is being required (e.g. `mailersend-ruby` requires `MAILERSEND_API_TOKEN`), load the environment explicitly before `Bundler.require` in `config/application.rb`:

  ```ruby
  require 'rails/all'
  require 'remote_env_loader'
  RemoteEnvLoader::Rails.load

  Bundler.require(*Rails.groups)
  ```

  The environment is loaded at most once per process: after a successful early load, the Railtie hook skips loading. If the early load fails, the Railtie hook retries once.

Configuration
-----------------

Create remote_env_loader.yml in config folder. Add app_name key with name of heroku app with environment variables. You can add app_name per rails environment. Enviroment scoped app takes priority.

```
app_name: 'example-app'

development:
  app_name: 'example-app-dev'
production:
  app_name: 'example-app-production'
test:
  app_name: 'example-app-test'
```

When running application, VAULT_TOKEN env variable with heroku access token is required to load env from heroku. This needs to be present directly on machine running the app. If `VAULT_TOKEN` or the app name is missing (e.g. on a local machine), loading is skipped silently. If loading fails, a warning is printed and the app keeps booting.


