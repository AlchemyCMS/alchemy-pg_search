require "spec_helper"

RSpec.shared_examples_for "it is searchable" do |attribute|
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

RSpec.shared_examples_for "a searchable content" do
  it "has searchable content" do
    expect(ingredient.searchable_content).to eq("foo bar")
  end

  context "whitespaces" do
    let(:content) { "   foo\n bar   "}

    it "has removed unnecessary whitespaces" do
      expect(ingredient.searchable_content).to eq("foo bar")
    end
  end
end

describe Alchemy::Ingredient do
  let(:element) do
    page_version = create(:alchemy_page_version, :published)
    create(:alchemy_element, :with_ingredients, name: "ingredient_test", public: true, page_version: page_version)
  end

  let(:content) { "foo bar" }

  describe Alchemy::Ingredients::Text do
    let(:ingredient) { create(:alchemy_ingredient_text, value: content, element: element) }

    it_behaves_like "it is searchable", field: :value
    it_behaves_like "a searchable content"
  end

  describe Alchemy::Ingredients::Headline do
    let(:ingredient) { create(:alchemy_ingredient_headline, value: "foo bar", element: element) }

    it_behaves_like "it is searchable", field: :value
    it_behaves_like "a searchable content"
  end

  describe Alchemy::Ingredients::Richtext do
    let(:ingredient) { create(:alchemy_ingredient_richtext, value: "<b>foo</b> bar", element: element) }

    it_behaves_like "it is searchable", field: :stripped_body
    it_behaves_like "a searchable content"
  end

  describe Alchemy::Ingredients::Picture do
    let(:ingredient) { create(:alchemy_ingredient_picture, value: create(:alchemy_picture), caption: content, element: element) }

    it_behaves_like "it is searchable", field: :caption
    it_behaves_like "a searchable content"
  end
end
