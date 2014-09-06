require 'rails_helper'

RSpec.describe GlobalSettingsSyncService do
  describe "#call" do
    let(:static_settings) { {'s3:a' => 'v3', 's3:b' => 'v4', 's3:c' => 'v5', 's4' => '2'} }
    let(:deprecated_ns) { 'other' }
    let(:actual_ns) { 'recommendations' }
    subject { GlobalSettingsSyncService.new.call }
    before do
      FactoryGirl.create(:dynamic_setting, ns: deprecated_ns, name: 's1', value: 'v1')
      FactoryGirl.create(:dynamic_setting, ns: actual_ns, name: 's2', value: 'v2')
      FactoryGirl.create(:dynamic_setting, ns: actual_ns, name: 's3:a', value: 'v3')
      FactoryGirl.create(:dynamic_setting, ns: actual_ns, name: 's3:b', value: 'v4')
      allow_any_instance_of(GlobalSettingsConverterService).to receive(:call).and_return(static_settings)
    end
    context "when deprecated namespace" do
      it "should remove all settings" do
        expect(DynamicSetting.where(ns: deprecated_ns).count).to eq(1)
        subject
        expect(DynamicSetting.where(ns: deprecated_ns).count).to be_zero
      end
    end
    context "when actual namespace" do
      it "should remove deprecated names" do
        expect(DynamicSetting.where(ns: actual_ns, name: ['s2']).count).to eq(1)
        subject
        expect(DynamicSetting.where(ns: actual_ns, name: ['s2']).count).to be_zero
      end
    end

    it "should not update actual settings" do
      expect(DynamicSetting.find_by(ns: actual_ns, name: 's3:a').value).to eq('v3')
      subject
      expect(DynamicSetting.find_by(ns: actual_ns, name: 's3:a').value).to eq('v3')
    end

    it "should add new settings" do
      expect(DynamicSetting.where(ns: actual_ns, name: 's3:c').count).to be_zero
      expect(DynamicSetting.where(ns: actual_ns, name: 's4').count).to be_zero
      subject
      expect(DynamicSetting.where(ns: actual_ns, name: 's3:c').first.value).to eq('v5')
      expect(DynamicSetting.where(ns: actual_ns, name: 's4').first.value).to eq('2')
    end
  end
end