require 'spec_helper'

describe Alchemy::PgSearch do
  let(:page_version) { create(:alchemy_page_version, :published) }
  let(:ingredient_element) { create(:alchemy_element, :with_ingredients, name: "ingredient_test", public: true, page_version: page_version) }

  let(:prepared_ingredients) do
    { :ingredient_text => :value, :ingredient_richtext => :value, :ingredient_picture => :value }.each do |ingredient_name, field|
      ingredient = ingredient_element.ingredient_by_role(ingredient_name)
      ingredient[field] = "foo"
      ingredient.save
    end
  end
  let(:first_page) { Alchemy::Page.first }
  let(:second_page) { Alchemy::Page.last }

  context 'rebuild' do
    it 'should have zero indexed documents' do
      expect(PgSearch::Document.count).to be(0)
    end

    context 'after rebuild' do
      before do
        prepared_ingredients
        Alchemy::PgSearch.rebuild
      end

      it 'should have entries (2 Pages + 3 Ingredients)' do
        expect(PgSearch::Document.count).to eq(5)
      end


      it "should have three ingredients" do
        expect(PgSearch::Document.where(searchable_type: "Alchemy::Ingredient").count).to eq(3)
      end
    end
  end

  context 'remove_page' do
    before do
      prepared_ingredients
      Alchemy::PgSearch.rebuild
    end

    context 'remove first page' do
      before { Alchemy::PgSearch.remove_page first_page }

      it 'should have only one page and relative ingredients (1 Page + 3 Ingredients)' do
        expect(PgSearch::Document.count).to eq(4)
      end

      it 'should have one page entry' do
        expect(PgSearch::Document.where(searchable_type: "Alchemy::Page").count).to eq(1)
      end
    end

    context 'remove second page' do
      before { Alchemy::PgSearch.remove_page second_page }

      it 'should have only one page (1 Page)' do
        expect(PgSearch::Document.count).to eq(1)
      end

      it 'should have one page entry' do
        expect(PgSearch::Document.where(searchable_type: "Alchemy::Page").count).to eq(1)
      end
    end
  end

  context 'index_page' do

    before do
      prepared_ingredients
      PgSearch::Document.destroy_all # clean the whole index
    end

    it 'should have zero indexed documents' do
      expect(PgSearch::Document.count).to be(0)
    end

    context 'first_page' do
      before do
        Alchemy::PgSearch.index_page first_page
      end

      it 'should have only one entry' do
        expect(PgSearch::Document.count).to be(1)
      end

      it 'should be the first page' do
        expect(PgSearch::Document.first.page_id).to be(first_page.id)
      end
    end

    context 'second_page' do
      before do
        Alchemy::PgSearch.index_page second_page
      end

      it 'should have four entries (1 Page + 3 Ingredients)' do
        expect(PgSearch::Document.count).to be(4)
      end

      it 'should be all relate to the same page ' do
        PgSearch::Document.all.each do |document|
          expect(document.page_id).to be(second_page.id)
        end
      end
    end

    context 'nested elements' do
      let!(:nested_element) { create(:alchemy_element, :with_ingredients, name: "article", public: true, page_version: page_version, parent_element: ingredient_element) }

      before do
        Alchemy::PgSearch.index_page second_page
      end

      it 'should have 6 documents' do
        # 1 Page + 3 previous ingredients + 2 new article ingredients
        expect(PgSearch::Document.count).to be(6)
      end

      it 'should be all relate to the same page ' do
        PgSearch::Document.all.each do |document|
          expect(document.page_id).to be(second_page.id)
        end
      end
    end

    context 'page searchable' do
      let(:searchable) { true }
      let!(:page) { create(:alchemy_page, :public, name: "Searchable Page", searchable: searchable) }
      let(:result) { Alchemy::PgSearch.search "searchable" }

      before do
        Alchemy::PgSearch.rebuild
      end

      it 'should find one page' do
        expect(result.length).to eq(1)
      end

      context 'searchable disabled' do
        let(:searchable) { false }

        it 'should not find any page' do
          expect(result.length).to eq(0)
        end
      end
    end
  end

  context 'search' do
    let(:result) { Alchemy::PgSearch.search "foo" }
    
    before do
      create(:alchemy_page, :restricted, :public, name: "foo")
      prepared_ingredients
      Alchemy::PgSearch.rebuild
    end

    it 'should find two pages' do
      expect(result.length).to eq(2)
    end

    context 'ability' do
      let(:user) { User.create(alchemy_roles: ["member"]) }
      let(:result) { Alchemy::PgSearch.search "foo", ability: Alchemy::Permissions.new(user) }

      context 'with a logged in user' do
        it 'should find two pages' do
          expect(result.length).to eq(2)
        end
      end

      context 'with an unknown user' do
        let(:user) { User.create(alchemy_roles: []) }

        it 'should find one page' do
          expect(result.length).to eq(1)
        end

        it 'should find only the second page' do
          expect(result.take.page).to eq(second_page)
        end
      end
    end
  end
end
