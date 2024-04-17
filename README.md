Remote Env Loader
==============

Installation
-----------------

  Add to Gemfile:
  
  gem 'remote_env_loader', git: 'https://github.com/kolosek/remote_env_loader.git', branch: 'master'

  Add `require 'remote_env_loader'` to config/application.rb

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

When running application, VAULT_TOKEN env variable with heroku access token is required to load env from heroku. This needs to be present directly on machine running the app.


