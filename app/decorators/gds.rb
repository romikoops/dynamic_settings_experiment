# Global Dynamic Setting
#
# Example:

#   GDS.get(:recommendation, :like_score_factor)


require 'singleton'
require 'redis-namespace'
require Rails.root.join('lib/simple_redis_data_provider')

class GDS
  MissingSettingError = Class.new(StandardError)

  attr_accessor :ns, :name
  include Singleton

  class << self
    delegate :get, :set, :flush_cache, to: :instance, allow_nil: false
  end

  def get(ns, name)
    self.ns = ns
    self.name = name
    get_from_cache || get_from_db || raise_missing_setting_error
  end

  def set(id, value)
    setting = DynamicSetting.find(id)
    setting.update(value: value).tap { cached_data_provider.set(setting.ns, setting.name, value) }
  end

  def flush_cache
    cached_data_provider.flush
  end


  private

  def initialize
    flush_cache
  end

  def cached_data_provider
    @_cached_data_provider ||= SimpleRedisDataProvider.new(:gds, Redis.current)
  end

  def raise_missing_setting_error
    raise MissingSettingError.new("Global Dynamic setting is missing(ns: #{ns.inspect}, name: #{name.inspect})")
  end

  def get_from_cache
    cached_data_provider.get(ns, name)
  end

  def get_from_db
    value = DynamicSetting.find_by(ns: ns, name: name).try(:value)
    cached_data_provider.set(ns, name, value) unless value.nil?
    value
  end
end