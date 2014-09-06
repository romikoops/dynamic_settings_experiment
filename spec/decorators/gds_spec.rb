require 'rails_helper'

RSpec.shared_examples "Global Dynamic Setting" do |owner|
  let(:ns) { 'foo' }
  let(:name) { 'bar'}
  let(:value) { 'baz' }
  before { GDS.flush_cache }
  describe "#get" do
    subject { owner.get(ns, name) }
    context "when cached" do
      before { Redis.current.hset "gds:#{ns}", name, value }
      it { is_expected.to eq(value) }
      it { expect(DynamicSetting.find_by(ns: ns, name: name, value: value)).to be_nil }
    end
    context "when not cached" do
      context "when found in db" do
        before { DynamicSetting.create(ns: ns, name: name, value: value)}
        it { is_expected.to eq(value) }
        it { expect(DynamicSetting.find_by(ns: ns, name: name)).to_not be_nil }
      end
      context "when not found in db" do
        it { expect{subject}.to raise_error(GDS::MissingSettingError, "Global Dynamic setting is missing(ns: #{ns.inspect}, name: #{name.inspect})") }
      end
    end
  end

  describe "#set" do
    let(:ds) { DynamicSetting.create(ns: ns, name: name, value: value) }
    subject { owner.set(ds.id, value) }
    before { subject }
    it { expect(DynamicSetting.find_by(ns: ns, name: name)).to_not be_nil }
    it { expect(Redis.current.hget "gds:#{ns}", name).to eq(value) }
  end

  describe "#flush_cache" do
    subject { owner.flush_cache }
    before do
      Redis.current.hset "gds:#{ns}", name, value
      Redis.current.hset "ruby", 'foo', 'bar'
      subject
    end
    it { expect(Redis.current.hget "ruby", 'foo').to eq('bar') }
    it { expect(Redis.current.hget "gds:#{ns}", name).to be_nil }
  end
end

RSpec.describe "singleton instance" do
  it_behaves_like "Global Dynamic Setting", GDS.instance
end

RSpec.describe GDS do
  it_behaves_like "Global Dynamic Setting", GDS
end