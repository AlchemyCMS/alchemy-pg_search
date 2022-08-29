require "spec_helper"

RSpec.describe PgSearch::Document do
  let(:document) { PgSearch::Document.new }
  let(:page) { create(:alchemy_page) }

  describe "page relation" do
    it "should not have a page entry if it does not have a relation" do
      expect(document.page).to be_nil
    end

    context "with page id" do
      let(:document) { PgSearch::Document.new(page_id: page.id) }

      it "should have a page entry" do
        expect(document.page).to eq(page)
      end
    end
  end

  describe "excerpts" do
    it "should be empty if the content is nil" do
      expect(document.excerpts).to eq([])
    end

    context "with no json" do
      let(:document) { PgSearch::Document.new(content: "123") }

      it "should be empty if the content is a not valid json" do
        expect(document.excerpts).to eq([])
      end
    end

    context "with valid json" do
      let(:document) { PgSearch::Document.new(content: '["123", "456"]') }

      it "should have an array of the json content" do
        expect(document.excerpts).to eq(%w[123 456])
      end
    end
  end
end
