class GlobalSettingsSyncService
  def call
    remove_all_with_unknown_ns
    DynamicSetting::KNOWN_GLOBAL_SETTINGS.each { |ns| merge_ns_settings(ns) }
  end

  private
  def merge_ns_settings(ns)
    default_dynamic_settings = ::GlobalSettingsConverterService.new(ns).call
    remove_all_with_unknown_names(ns, default_dynamic_settings.keys)
    default_dynamic_settings.each do |k, v|
      DynamicSetting.find_or_create_by!(ns: ns, name: k) {|s| s.value = v.to_s}
    end
  end

  def remove_all_with_unknown_ns
    DynamicSetting.where.not(ns: DynamicSetting::KNOWN_GLOBAL_SETTINGS).destroy_all
  end

  def remove_all_with_unknown_names(ns, known_names)
    DynamicSetting.where(ns: ns).where.not(name: known_names).destroy_all
  end

end