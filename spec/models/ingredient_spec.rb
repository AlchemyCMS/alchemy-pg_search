require "spec_helper"

describe Alchemy::Ingredient do
  let(:element) do
    page_version = create(:alchemy_page_version, :published)
    create(:alchemy_element, :with_contents, name: "ingredient_test", public: true, page_version: page_version)
  end

  Alchemy::PgSearch::SEARCHABLE_INGREDIENTS.each do |ingredient_type|
    context ingredient_type do
      let(:ingredient) { create(:"alchemy_ingredient_#{ingredient_type.downcase}", value: "foo", element: element) }

      context "searchable?" do
        context "element and ingredient are searchable" do
          it "should be searchable" do
            expect(ingredient.searchable?).to be(true)
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

      context "index" do
        let(:document) { PgSearch::Document.first }
        before do
          ingredient
          ::PgSearch::Multisearch.rebuild Alchemy::Ingredient
        end

        it "should have one entry" do
          expect(PgSearch::Document.all.length).to eq(1)
        end

        it "should be the current ingredient" do
          expect(document.searchable).to eq(ingredient)
        end
      end
    end
  end

  context "not supported ingredient type" do
    let(:ingredient) { create(:"alchemy_ingredient_boolean", value: true, element: element) }

    context "searchable?" do
      it "should be not searchable" do
        expect(ingredient.searchable?).to be(false)
      end
    end

    context "index" do
      let(:document) { PgSearch::Document.first }
      before do
        ingredient
        ::PgSearch::Multisearch.rebuild Alchemy::Ingredient
      end

      it "should have no entries" do
        expect(PgSearch::Document.all.length).to eq(0)
      end
    end
  end
end
