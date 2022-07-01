require "spec_helper"

RSpec.describe Alchemy::Content do
  let(:element) { create(:alchemy_element, :with_contents, name: "content_test") }
  let(:content) { element.content_by_name(content_name) }
  let(:content_name) { :without_searchable }

  context "Without searchable" do
    let(:content_name) { :without_searchable }

    it "should be searchable" do
      expect(content.searchable).to be(true)
    end
  end

  context "With searchable enabled" do
    let(:content_name) { :with_searchable_enabled }

    it "should be searchable" do
      expect(content.searchable).to be(true)
    end
  end

  context "With searchable disabled" do
    let(:content_name) { :with_searchable_disabled }

    it "should be not searchable" do
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
