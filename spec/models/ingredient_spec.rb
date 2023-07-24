require "spec_helper"

RSpec.shared_examples_for "it is searchable" do
  describe "searchable?" do
    subject { ingredient.searchable? }

    context "element and ingredient are searchable" do
      it { is_expected.to be(true) }

      context "but configured as not searchable" do
        before do
          expect(ingredient).to receive(:definition).at_least(:once) do
            {
              searchable: false,
            }
          end
        end

        it { is_expected.to be(false) }
      end
    end

    context "ingredient has no content" do
      it "should be not searchable" do
        ingredient.value = nil
        expect(ingredient.searchable?).to be(false)
      end
    end

    context "element is not public" do
      it "should be not searchable" do
        element.public = false
        expect(ingredient.searchable?).to be(false)
      end
    end

    context "ingredient has no related content" do
      let(:ingredient) { create(:alchemy_ingredient_text) }

      it "should be not searchable" do
        expect(ingredient.searchable?).to be(false)
      end
    end
  end
end

RSpec.shared_examples_for "it is in search index" do
  describe "search index" do
    let(:document) { PgSearch::Document.first }

    subject do
      ingredient
      ::PgSearch::Multisearch.rebuild described_class
    end

    it "should have one entry" do
      subject
      expect(PgSearch::Document.where(searchable_type: "Alchemy::Ingredient").count).to eq(1)
    end

    it "should have the content" do
      subject
      expect(PgSearch::Document.first.content).to eq(content)
    end

    context "configured as not searchable" do
      before do
        allow_any_instance_of(ingredient.class).to receive(:definition).at_least(:once) do
          {
            searchable: false,
          }
        end
      end

      it "should have no index entry" do
        subject
        expect(PgSearch::Document.where(searchable_type: "Alchemy::Ingredient").count).to eq(0)
      end
    end

    it "should be the current ingredient" do
      subject
      expect(document.searchable).to eq(ingredient)
    end
  end
end

describe Alchemy::Ingredient do
  let(:element) do
    page_version = create(:alchemy_page_version, :published)
    create(:alchemy_element, :with_ingredients, name: "ingredient_test", public: true, page_version: page_version)
  end

  let(:content) { "foo bar"}

  describe Alchemy::Ingredients::Text do
    let(:ingredient) { create(:alchemy_ingredient_text, value: content, element: element) }

    it_behaves_like "it is searchable"
    it_behaves_like "it is in search index"
  end

  describe Alchemy::Ingredients::Richtext do
    let(:ingredient) { create(:alchemy_ingredient_richtext, value: content, element: element) }

    it_behaves_like "it is searchable"
    it_behaves_like "it is in search index"
  end

  describe Alchemy::Ingredients::Picture do
    let(:ingredient) { create(:alchemy_ingredient_picture, value: create(:alchemy_picture), caption: content, element: element) }

    it_behaves_like "it is searchable"
    it_behaves_like "it is in search index"
  end
end
