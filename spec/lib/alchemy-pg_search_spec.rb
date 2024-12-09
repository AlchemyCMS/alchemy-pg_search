require 'spec_helper'

describe Alchemy::PgSearch do
  let!(:first_page) { create(:alchemy_page, :public) }
  let!(:second_page) { create(:alchemy_page, :public) }
  
  describe '#rebuild' do
    subject { described_class.rebuild }

    it 'should have created pages indexed documents' do
      expect(PgSearch::Document.count).to be(2)
    end

    it "has an additional page (Root Page + 2 created pages)" do
      expect { subject }.to change { PgSearch::Document.count }.by(1)
    end

    context "with parameter" do
      it "calls PgSearch::Multisearch.rebuild with clean_up and transactional enabled" do
        expect(::PgSearch::Multisearch).to receive(:rebuild).with(Alchemy::Page, clean_up: true, transactional: true)
        subject
      end

      it "calls PgSearch::Multisearch.rebuild with clean_up and transactional disabled" do
        expect(::PgSearch::Multisearch).to receive(:rebuild).with(Alchemy::Page, clean_up: false, transactional: false)
        described_class.rebuild(clean_up: false, transactional: false)
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

        context "with other search documents" do
          let!(:other_search_document) do
            PgSearch::Document.new(content: "Page").save(validate: false)
          end

          it 'should find three pages' do
            expect(result.length).to eq(3)
          end
        end
      end
    end
  end
end
