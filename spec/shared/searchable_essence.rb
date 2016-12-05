require 'spec_helper'

shared_examples_for 'an searchable essence' do
  let(:essence_type) { essence_class.model_name.name.demodulize }
  let(:content)      { create(:alchemy_content) }

  before do
    allow(content).to receive(:essence_class).and_return(essence_class)
  end

  context 'with searchable set to true' do
    before do
      allow(content).to receive(:definition).and_return({
        'type' => essence_type,
        'searchable' => true
      })
    end

    it "sets the searchable attribute to true" do
      content.create_essence!
      expect(content.essence.searchable).to be(true)
    end
  end

  context 'with searchable set to false' do
    before do
      allow(content).to receive(:definition).and_return({
        'type' => essence_type,
        'searchable' => false
      })
    end

    it "sets the searchable attribute to false" do
      content.create_essence!
      expect(content.essence.searchable).to be(false)
    end
  end

  context 'with searchable key missing' do
    before do
      allow(content).to receive(:definition).and_return({
        'type' => essence_type
      })
    end

    it "sets the searchable attribute to true" do
      content.create_essence!
      expect(content.essence.searchable).to be(true)
    end
  end
end
