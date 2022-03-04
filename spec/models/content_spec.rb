require "spec_helper"

RSpec.describe Alchemy::Content do
  let(:element) { build(:alchemy_element, name: "foo") }

  let(:content) do
    described_class.new(definition.merge(element: element))
  end

  let(:definition) do
    {
      name: "bar",
      type: essence_type,
      searchable: searchable,
    }.with_indifferent_access
  end

  let(:searchable) { true }
  let(:essence_type) { "EssenceText" }

  before do
    expect(element).to receive(:content_definition_for).at_least(:once) do
      definition
    end
  end

  context "with searchable set to true" do
    let(:searchable) { true }

    it "sets the searchable attribute to true" do
      expect(content.searchable).to be(true)
    end
  end

  context "with searchable set to false" do
    let(:searchable) { false }

    it "sets the searchable attribute to false" do
      expect(content.searchable).to be(false)
    end
  end

  context "with searchable key missing" do
    let(:definition) do
      {
        name: "bar",
        type: essence_type,
      }.with_indifferent_access
    end

    it "sets the searchable attribute to true" do
      expect(content.searchable).to be(true)
    end
  end

  describe ".after_update" do
    let(:element) { create(:alchemy_element, name: "foo") }

    let(:content) do
      described_class.create(definition.merge(element: element))
    end

    let(:definition) do
      {
        name: "bar",
        type: "EssenceText",
        searchable: true,
      }.with_indifferent_access
    end

    it "updates the value for `searchable`" do
      content.update!(searchable: false)
      expect(content.searchable).to be(false)
    end
  end

  describe "#searchable_ingredient" do
    subject { content.searchable_ingredient }

    before do
      expect(content).to receive(:essence_type) { essence_type }
      expect(content).to receive(:essence) { essence }
    end

    context "for a EssenceText" do
      let(:essence_type) { "Alchemy::EssenceText" }
      let(:essence) { double(body: "The title") }

      it "returns the body" do
        expect(subject).to eq("The title")
      end
    end

    context "for a EssenceRichtext" do
      let(:essence_type) { "Alchemy::EssenceRichtext" }
      let(:essence) { double(stripped_body: "The text") }

      it "returns the stripped body" do
        expect(subject).to eq("The text")
      end
    end

    context "for a EssencePicture" do
      let(:essence_type) { "Alchemy::EssencePicture" }
      let(:essence) { double(caption: "The caption") }

      it "returns the caption" do
        expect(subject).to eq("The caption")
      end
    end
  end
end
