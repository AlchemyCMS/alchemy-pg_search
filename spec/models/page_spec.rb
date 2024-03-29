require "spec_helper"

RSpec.describe Alchemy::Page do
  let(:page) { create(:alchemy_page, :public) }

  describe "searchable?" do
    subject { page.searchable? }

    context "public and not restricted page" do
      it { is_expected.to be(true) }

      context "but configured as not searchable" do
        before do
          expect(page).to receive(:definition).at_least(:once) do
            {
              searchable: false,
            }
          end
        end

        it { is_expected.to be(false) }
      end
    end

    context "not public page" do
      let(:page) { create(:alchemy_page) }

      it { is_expected.to be(false) }
    end

    context "layout page" do
      let(:page) { create(:alchemy_page, :public, :layoutpage) }

      it { is_expected.to be(false) }
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

    context "but configured as not searchable" do
      before do
        expect(page).to receive(:definition).at_least(:once) do
          {
            searchable: false,
          }
        end
      end

      it "should remove the document" do
        page.save
        expect(PgSearch::Document.count).to eq(0)
      end
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
