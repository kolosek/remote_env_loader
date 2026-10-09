# frozen_string_literal: true

module RemoteEnvLoader
  extend self

  def load(app_name, token, overwrite: false)
    return if app_name.to_s.empty? || token.to_s.empty?

    uri = URI("https://api.heroku.com/apps/#{app_name}/config-vars")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.open_timeout = 5
    http.read_timeout = 10
    req = Net::HTTP::Get.new(uri, { Authorization: "Bearer #{token}", Accept: 'application/vnd.heroku+json; version=3' })
    res = http.request(req)

    unless res.is_a?(Net::HTTPSuccess)
      warn "RemoteEnvLoader: could not load environment from #{app_name} (#{res.code} #{res.message})"
      return
    end

    remote_env = JSON.parse(res.body)
    ENV.update(remote_env.transform_keys(&:to_s)) do |key, old_value, new_value|
      overwrite ? new_value : old_value
    end
    puts "Loaded #{remote_env.keys.size} env variables from #{app_name}"
  rescue StandardError => e
    warn "RemoteEnvLoader: could not load environment from #{app_name} (#{e.class}: #{e.message})"
  end
end

require "remote_env_loader/rails" if defined?(Rails::Railtie)
