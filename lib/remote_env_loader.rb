# frozen_string_literal: true

module RemoteEnvLoader
  extend self

  def load(app_name, token, overwrite: false)
    uri = URI("https://api.heroku.com/apps/#{app_name}/config-vars")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    req = Net::HTTP::Get.new(uri, { Authorization: "Bearer #{token}", Accept: 'application/vnd.heroku+json; version=3' })
    res = http.request(req)
    remote_env = JSON.parse(res.body)

    unless remote_env['id'] == 'unauthorized' || remote_env['id'] == 'not_found'
      ENV.update(remote_env.transform_keys(&:to_s)) do |key, old_value, new_value|
        overwrite ? new_value : old_value
      end
      puts "Loaded #{remote_env.keys.size} env variables from #{app_name}"
    else
      puts 'Could not load environment'
    end
  end
end

require "remote_env_loader/rails" if defined?(Rails::Railtie)