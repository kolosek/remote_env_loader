# frozen_string_literal: true

require_relative "lib/remote_env_loader/version"

Gem::Specification.new do |spec|
  spec.name          = "remote_env_loader"
  spec.version       = RemoteEnvLoader::VERSION
  spec.authors       = ["Kolosek"]
  spec.email         = ["office@kolosek.com"]

  spec.summary       = "Load ENV variables from Heroku app"
  spec.description   = "Load ENV variables from Heroku app"
  spec.homepage      = "https://github.com/RubyCI/remote_env_loader"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.4.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end

  spec.require_paths = ["lib"]

  spec.add_dependency "railties", ">= 6.1"
  spec.add_development_dependency "pry"
end
