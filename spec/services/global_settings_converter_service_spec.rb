require 'rails_helper'

RSpec.describe GlobalSettingsConverterService do
  describe ".new" do
    let(:value) { '123' }
    subject { GlobalSettingsConverterService.new(value) }
    its(:settings_name){ is_expected.to eq(value)}
  end

  describe "#call" do
    let(:ns) { 'recommendations' }
    let(:static_settings) { {s3: {a: 'v3', b: :v4, c: 'v5'}, s4: 2} }
    subject { GlobalSettingsConverterService.new(ns).call }
    before do
      def Global.recommendations; super; end
      allow(Global).to receive(:recommendations){ static_settings }
    end

    it { is_expected.to eq('s3:a' => 'v3', 's3:b' => 'v4', 's3:c' => 'v5', 's4' => '2') }
  end
end