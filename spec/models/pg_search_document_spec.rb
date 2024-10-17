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
end
