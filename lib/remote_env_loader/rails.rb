require 'uri'
require 'net/http'
require 'json'

module RemoteEnvLoader
  class Rails < ::Rails::Railtie
    delegate :app_name, :token, :overwrite, :overwrite=, to: "config.remote_env_loader"

    def initialize
      super()

      yaml_config = begin
        YAML.load_file(root.join('config/remote_env_loader.yml').to_s)
      rescue
        {}
      end

      app_name = (yaml_config[env] || {})['app_name'] || yaml_config['app_name'] || ENV['REMOTE_APP_NAME']
      token = ENV['VAULT_TOKEN']

      config.remote_env_loader = ActiveSupport::OrderedOptions.new.update(
        app_name: app_name,
        token: token,
        overwrite: false
      )
    end

    def load
      RemoteEnvLoader.load(app_name, token, overwrite: overwrite)
    end

    def root
      ::Rails.root || Pathname.new(ENV["RAILS_ROOT"] || Dir.pwd)
    end

    def env
      @env ||= if defined?(Rake.application) && Rake.application.top_level_tasks.grep(TEST_RAKE_TASKS).any?
        env = Rake.application.options.show_tasks ? "development" : "test"
        ActiveSupport::EnvironmentInquirer.new(env)
      else
        ::Rails.env
      end
    end
    TEST_RAKE_TASKS = /^(default$|test(:|$)|parallel:spec|spec(:|$))/

    def self.load
      instance.load
    end

    config.before_configuration { load }
  end
end








