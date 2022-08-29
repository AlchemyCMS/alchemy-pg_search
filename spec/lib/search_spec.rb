require 'spec_helper'

describe Alchemy::PgSearch::Search do
  let(:page_version) { create(:alchemy_page_version, :published) }
  let(:element) { create(:alchemy_element, :with_contents, name: "essence_test", public: true, page_version: page_version) }
  let(:prepared_essences) do
    { :essence_text => :body, :essence_richtext => :body, :essence_picture => :caption }.each do |essence_name, field|
      essence = element.content_by_name(essence_name).essence
      essence[field] = "foo"
      essence.save
    end
  end
  let(:prepared_ingredients) do
    Alchemy::PgSearch::SEARCHABLE_INGREDIENTS.each do |ingredient_type|
      create(:"alchemy_ingredient_#{ingredient_type.downcase}", value: "foo", element: element)
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
        prepared_essences
        prepared_ingredients
        Alchemy::PgSearch::Search.rebuild
      end

      it 'should have entries (2 Pages + 3 Essences + 3 Ingredients)' do
        expect(PgSearch::Document.count).to eq(8)
      end

      ["Alchemy::EssenceText", "Alchemy::EssenceRichtext", "Alchemy::EssencePicture"].each do |model|
        it "should have a #{model}" do
          expect(PgSearch::Document.where(searchable_type: model).count).to eq(1)
        end
      end

      it "should have three ingredients" do
        expect(PgSearch::Document.where(searchable_type: "Alchemy::Ingredient").count).to eq(3)
      end
    end
  end

  context 'remove_page' do
    before do
      prepared_essences
      prepared_ingredients
      Alchemy::PgSearch::Search.rebuild
    end

    context 'remove first page' do
      before { Alchemy::PgSearch::Search.remove_page first_page }

      it 'should have only one page and relative essences/ingredients (1 Page + 3 Essences + 3 Ingredients)' do
        expect(PgSearch::Document.count).to eq(7)
      end

      it 'should have one page entry' do
        expect(PgSearch::Document.where(searchable_type: "Alchemy::Page").count).to eq(1)
      end
    end

    context 'remove second page' do
      before { Alchemy::PgSearch::Search.remove_page second_page }

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
      prepared_essences
      prepared_ingredients
      PgSearch::Document.destroy_all # clean the whole index
    end

    it 'should have zero indexed documents' do
      expect(PgSearch::Document.count).to be(0)
    end

    context 'first_page' do
      before do
        Alchemy::PgSearch::Search.index_page first_page
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
        Alchemy::PgSearch::Search.index_page second_page
      end

      it 'should have four entries (1 Page + 3 Essences + 3 Ingredients)' do
        expect(PgSearch::Document.count).to be(7)
      end

      it 'should be all relate to the same page ' do
        PgSearch::Document.all.each do |document|
          expect(document.page_id).to be(second_page.id)
        end
      end
    end

    context 'nested elements' do
      let(:nested_element) { create(:alchemy_element, :with_contents, name: "article", public: true, page_version: page_version, parent_element: element) }

      before do
        nested_element
        Alchemy::PgSearch::Search.index_page second_page
      end

      it 'should have 6 documents' do
        # 1 Page + 3 previous essences + 3 previous ingredients + 2 new article essences
        # the picture essence is empty and not in the search index
        expect(PgSearch::Document.count).to be(9)
      end

      it 'should be all relate to the same page ' do
        PgSearch::Document.all.each do |document|
          expect(document.page_id).to be(second_page.id)
        end
      end
    end
  end

  context 'search' do
    let(:result) { Alchemy::PgSearch::Search.search "foo" }
    
    before do
      create(:alchemy_page, :restricted, :public, name: "foo")
      prepared_essences
      Alchemy::PgSearch::Search.rebuild
    end

    it 'should find two pages' do
      expect(result.length).to eq(2)
    end

    context 'ability' do
      let(:user) { User.create(alchemy_roles: ["member"]) }
      let(:result) { Alchemy::PgSearch::Search.search "foo", ability: Alchemy::Permissions.new(user) }

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
          expect(result.first.page).to eq(second_page)
        end
      end
    end
  end
end
