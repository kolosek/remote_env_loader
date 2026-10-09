Remote Env Loader
==============

Installation
-----------------

  Add to Gemfile:
  
  ```
  gem 'remote_env_loader', git: 'https://github.com/kolosek/remote_env_loader.git', tag: 'v0.0.2'
  ```

  Pin to a release tag so updates are picked up deliberately. To upgrade, change the tag and run `bundle update remote_env_loader`.

  No other setup is needed: the gem registers a Railtie that loads the environment automatically before the app is configured. Do not call `RemoteEnvLoader::Rails.load` yourself, or the environment will be loaded twice.

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


