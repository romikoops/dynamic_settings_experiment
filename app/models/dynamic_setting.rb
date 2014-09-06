class DynamicSetting < ActiveRecord::Base
  KNOWN_GLOBAL_SETTINGS = [:recommendations] #specify here base names of Global configuration files

  validates :ns, presence: true
  validates :name, presence: true, uniqueness: {scope: :ns}

end