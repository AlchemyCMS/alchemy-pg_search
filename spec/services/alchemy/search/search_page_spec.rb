require "spec_helper"

RSpec.describe Alchemy::Search::SearchPage do
  let(:paginate_per) { 10 }
  before do
    Alchemy::PgSearch.config = {
      paginate_per:,
    }
  end

  context "#perform_search" do
    let(:query) {"foo"}
    let(:params) { {query:}}
    subject { described_class.perform_search(params, ability: nil) }

    it "calls the Alchemy.search_class" do
      expect(Alchemy.search_class).to receive(:search).with(query, ability: nil)
      subject
    end

    context "pagination" do
      let(:query) {"page"}

      before do
        12.times do
          create(:alchemy_page, :public)
        end
        Alchemy.search_class.rebuild
      end

      it "response with 10 documents" do
        expect(subject.length).to eq(10)
      end

      context "without pagination" do
        let(:paginate_per) { nil }

        it "response with all documents" do
          expect(subject.length).to eq(12)
        end
      end
    end

    context "sort" do
      let(:query) { "page" }
      let(:params) { {query:, sort:} }
      let!(:first_page) { create(:alchemy_page, :public, published_at: "1999-08-01 00:00") }
      let!(:second_page) { create(:alchemy_page, :public, title: "Page 2") }

      context "by relevance" do
        let(:sort) { "relevance" }

        it "sorts by pg_search ranking" do
          expect(subject.first.searchable).to eq(first_page)
        end
      end

      context "by date" do
        let(:sort) { "date" }

        it "sorts by searchable_created_at" do
          expect(subject.first.searchable).to eq(second_page)
        end
      end
    end
  end

  context '#paginate_per' do
    subject { described_class.paginate_per }

    it 'should be 10 if no configuration is set' do
      expect(subject).to eq(10)
    end

    context "with configuration" do
      let(:paginate_per) { 50 }

      it 'should be 50 if no configuration is set' do
        expect(subject).to eq(50)
      end
    end
  end
end
