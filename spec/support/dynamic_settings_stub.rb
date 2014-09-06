STATIC_SETTINGS = DynamicSetting::KNOWN_GLOBAL_SETTINGS.inject(HashWithIndifferentAccess.new) do |res, ns|
  res[ns] = GlobalSettingsConverterService.new(ns).call
  res
end

require Rails.root.join('app/decorators/gds')

class GDS
  class << self
    alias_method :orig_get, :get

    def get(ns, name)
      value = STATIC_SETTINGS.fetch(ns, {})[name]
      value = orig_get(ns, name) if value.nil?
      value
    end
  end
end