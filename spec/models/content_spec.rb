require "spec_helper"

RSpec.describe Alchemy::Content do
  let(:element_public) { true }
  let(:element) do
    page_version = create(:alchemy_page_version, :published)
    create(:alchemy_element, :with_contents, name: "content_test", public: element_public, page_version: page_version)
  end
  let(:content) { element.content_by_name(content_name) }
  let(:content_name) { :without_searchable }

  context "searchable?" do
    context "content and element are searchable" do
      it "should be searchable" do
        expect(content.searchable?).to be(true)
      end
    end

    context "content not marked as searchable" do
      let(:content_name) { :with_searchable_disabled }
      it "should not be searchable" do
        expect(content.searchable?).to be(false)
      end
    end

    context "related element not searchable" do
      let(:element_public) { false }
      it "should not be searchable" do
        expect(content.searchable?).to be(false)
      end
    end
  end

  context "Without searchable" do
    let(:content_name) { :without_searchable }

    it "should be marked as searchable" do
      expect(content.searchable).to be(true)
    end
  end

  context "With searchable enabled" do
    let(:content_name) { :with_searchable_enabled }

    it "should be marked as searchable" do
      expect(content.searchable).to be(true)
    end
  end

  context "With searchable disabled" do
    let(:content_name) { :with_searchable_disabled }

    it "should be not marked as searchable" do
      expect(content.searchable).to be(false)
    end
  end
end
