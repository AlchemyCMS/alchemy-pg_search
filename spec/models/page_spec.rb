require "spec_helper"

RSpec.describe Alchemy::Page do
  let(:page) { create(:alchemy_page, :public) }

  describe "searchable?" do
    describe "public and not restricted page" do
      let(:page) { create(:alchemy_page, :public) }

      it 'should be searchable' do
        expect(page.searchable?).to be(true)
      end
    end

    describe "not public page" do
      let(:page) { create(:alchemy_page) }

      it 'should not be searchable' do
        expect(page.searchable?).to be(false)
      end
    end

    describe "layout page" do
      let(:page) { create(:alchemy_page, :public, :layoutpage) }

      it 'should not be searchable' do
        expect(page.searchable?).to be(false)
      end
    end
  end

  describe "after save" do
    before do
      PgSearch::Document.create(page_id: page.id, content: "foo")
    end

    it "should not remove the document, if the page is searchable" do
      page.save
      expect(PgSearch::Document.count).to eq(1)
    end

    describe "unpublished page" do
      let(:page) { create(:alchemy_page) }

      it "should remove the document, if the page is not searchable" do
        page.save
        expect(PgSearch::Document.count).to eq(0)
      end
    end
  end
end
