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

    subject { page.save }

    it "should not remove the document, if the page is searchable" do
      expect { subject }.to change { PgSearch::Document.count }.by(0)
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
        expect { subject }.to change { PgSearch::Document.count }.by(-1)
      end
    end

    context "unpublished page" do
      let(:page) { create(:alchemy_page) }

      it "should not store the page, if it is not searchable" do
        expect(PgSearch::Document.count).to eq(0)
      end
    end

    context "stored content" do
      let!(:page) { create(:alchemy_page, :public, name: "Searchable Page", page_layout: "mixed", autogenerate_elements: true) }
      let(:content) { page.pg_search_document.content }

      before do
        subject
      end

      it "should store the page name" do
        expect(content).to start_with("Searchable Page")
      end

      it "should store the searchable_content" do
        expect(content).to include("public title")
      end
    end
  end

  describe "additional_attributes" do
    it "stores page_id" do
      expect(page.pg_search_document.page_id).to eq(page.id)
    end

    it "stores searchable created_at" do
      expect(page.pg_search_document.searchable_created_at).to eq(page.public_on)
    end
  end

  describe "searchable_content" do
    let!(:searchable_page) { create(:alchemy_page, :public, name: "Searchable Page", page_layout: "mixed", autogenerate_elements: true) }

    before do
      PgSearch::Document.destroy_all # clean the whole index
    end

    subject { searchable_page.searchable_content }

    it "has ingredients" do
      expect(subject).to include("public title")
    end

    it "hasn't not searchable ingredient" do
      expect(subject).to_not include("secret password")
    end

    it "stores stripped content from ingredient" do
      expect(subject).to include("public richtext")
    end
  end
end
