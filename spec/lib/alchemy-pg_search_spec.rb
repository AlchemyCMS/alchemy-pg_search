require 'spec_helper'

describe Alchemy::PgSearch do
  let!(:first_page) { create(:alchemy_page, :public) }
  let!(:second_page) { create(:alchemy_page, :public) }
  
  describe '#rebuild' do
    subject { described_class.rebuild }

    it 'should have both created pages indexed documents' do
      expect(PgSearch::Document.count).to be(2)
    end

    it "has 3 Pages (Root Page + 2 created pages)" do
      subject
      expect(PgSearch::Document.count).to be(3)
    end
  end

  describe "#remove_page" do
    subject { described_class.remove_page(first_page) }

    it "should remove the page from search index" do
      expect { subject }.to change { PgSearch::Document.count }.by(-1)
      expect(first_page.reload.pg_search_document).to be_nil
    end
  end

  describe "#index_page" do
    let!(:first_page) { create(:alchemy_page, :public, name: "Mixed", page_layout: "mixed", autogenerate_elements: true) }
    let(:content) { first_page.pg_search_document.content }

    before do
      PgSearch::Document.destroy_all # clean the whole index
    end

    subject { described_class.index_page(first_page.reload) }

    it "creates a new pg_search document" do
      expect { subject }.to change { PgSearch::Document.count }.by(1)
    end

    it "has the page title as content" do
      subject
      expect(content).to include("Mixed ")
    end

    it "has ingredient as content" do
      subject
      expect(content).to include("public title")
    end

    it "hasn't not searchable ingredient in content" do
      subject
      expect(content).to_not include("secret password")
    end

    it "stores stripped content from ingredient" do
      subject
      expect(content).to include("public richtext")
    end

    it "removes whitespace from content" do
      subject
      expect(content).to start_with("Mixed")
    end

    context "hidden page" do
      let!(:first_page) { create(:alchemy_page) }

      it "creates nothing" do
        expect { subject }.to change { PgSearch::Document.count }.by(0)
      end
    end
  end

  context 'search' do
    let!(:third_page) { create(:alchemy_page, :restricted, :public, name: "Third Page") }
    let(:ability) { nil }

    subject(:result) { Alchemy::PgSearch.search "page", ability: }

    it 'should find three pages' do
      expect(result.length).to eq(3)
    end

    context 'ability' do
      let(:user) { User.create(alchemy_roles: ["member"]) }
      let(:ability) { Alchemy::Permissions.new(user) }

      context 'with a logged in user' do
        it 'should find the restricted page' do
          expect(result.length).to eq(3)
          expect(result.last.page).to eq(third_page)
        end
      end

      context 'with an unknown user' do
        let(:user) { User.create(alchemy_roles: []) }

        it 'should find two pages' do
          expect(result.length).to eq(2)
        end
      end
    end
  end
end
