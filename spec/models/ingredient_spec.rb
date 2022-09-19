require "spec_helper"

describe Alchemy::Ingredient do
  let(:element) do
    page_version = create(:alchemy_page_version, :published)
    create(:alchemy_element, :with_contents, name: "ingredient_test", public: true, page_version: page_version)
  end

  Alchemy::PgSearch::SEARCHABLE_INGREDIENTS.each do |ingredient_type|
    describe ingredient_type do
      let(:ingredient) { create(:"alchemy_ingredient_#{ingredient_type.downcase}", value: "foo", element: element) }

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

      context "index" do
        let(:document) { PgSearch::Document.first }

        subject do
          ingredient
          ::PgSearch::Multisearch.rebuild Alchemy::Ingredient
        end

        it "should have one entry" do
          subject
          expect(PgSearch::Document.where(searchable_type: "Alchemy::Ingredient").count).to eq(1)
        end

        context "configured as not searchable" do
          before do
            expect_any_instance_of(ingredient.class).to receive(:definition).at_least(:once) do
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
