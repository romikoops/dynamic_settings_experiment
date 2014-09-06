require 'rails_helper'

RSpec.describe DynamicSetting, type: :model do
  describe "factories" do
    subject { FactoryGirl.build(:dynamic_setting) }
    it { is_expected.to be_valid }
  end
end