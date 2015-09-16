require 'active_support/configurable'

module ActiveMultipleDb
  def self.configure(&block)
    yield @config ||= ActiveMultipleDb::Configuration.new
  end

  def self.config
    @config
  end

  class Configuration
    include ActiveSupport::Configurable

    # This does not have Rails 3.2 compatibility
    # We can set up config_accessor with a default value by block from Rails 4.0
    # https://github.com/rails/rails/commit/1efe30ebcef2e6d3967742f9bcf4f6675a946d14
    config_accessor :safely_yielding_environments do
      ["development", "test"]
    end
  end

  # Initialize config
  configure {}
end
