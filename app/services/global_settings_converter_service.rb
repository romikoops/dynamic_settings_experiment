class GlobalSettingsConverterService < Struct.new(:settings_name)
  def call
    convert(static_global_settings)
  end

  private
  def static_global_settings
    Global.send(settings_name).to_hash
  end

  def convert(root=nil, value)
    if value.is_a? Hash
      value.inject(HashWithIndifferentAccess.new) do |res, (k, v)|
        res.merge(convert([root, k].compact.join(':'), v))
      end
    else
      HashWithIndifferentAccess.new(root => value.to_s)
    end
  end
end