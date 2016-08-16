require 'spec_helper'

module Alchemy
  describe 'Fulltext search' do
    let!(:search_page) do
      create(:alchemy_page, :public, name: 'Suche', page_layout: 'search', do_not_autogenerate: false)
    end

    it "form has correct path in the form tag" do
      visit('/suche')
      expect(page).to have_selector('form[action="/suche"]')
    end

    context 'displaying search results' do
      let!(:public_page) { create(:alchemy_page, :public, visible: true, name: 'Page 1') }
      let!(:element)     { create(:alchemy_element, page: public_page, create_contents_after_create: true) }

      it "displays search results from text essences" do
        visit('/suche?query=search')
        within('.search_results') do
          expect(page).to have_content('This is a headline everybody should be able to search for.')
        end
      end

      it "displays search results from richtext essences" do
        visit('/suche?query=search')
        within('.search_results') do
          expect(page).to have_content('This is a text block everybody should be able to search for.')
        end
      end

      it "displays search results from picture essences" do
        element.contents.essence_pictures.first.essence.update!(caption: 'This is a caption everybody should be able to search for.')
        visit('/suche?query=caption')
        within('.search_results') do
          expect(page).to have_content('This is a caption everybody should be able to search for.')
        end
      end

      context 'with unsearchable contents' do
        let!(:secret_element) do
          create(:alchemy_element, name: 'secrets', page: public_page, create_contents_after_create: true)
        end

        before do
          secret_element.contents.essence_pictures.first.essence.update!(caption: 'This is a secret caption.')
        end

        it "does not display results from unsearchable contents" do
          visit('/suche?query=This')
          expect(page).to_not have_content('This is my secret password')
          expect(page).to_not have_content('This is some confidential text')
          expect(page).to_not have_content('This is a secret caption')
        end
      end

      it "does not display results placed on global pages" do
        public_page.update!(layoutpage: true)
        visit('/suche?query=search')
        expect(page).to have_css('h2.no_search_results')
      end

      it "does not display results placed on unpublished pages" do
        public_page.update!(public_on: nil)
        visit('/suche?query=search')
        expect(page).to have_css('h2.no_search_results')
      end

      describe 'content from restricted pages' do
        before { public_page.update!(restricted: true) }

        it "does not display any result" do
          visit('/suche?query=search')
          expect(page).to have_css('h2.no_search_results')
        end

        context 'as member user' do
          let!(:member) do
            user = User.new
            user.alchemy_roles = %w(member)
            user
          end

          before do
            allow_any_instance_of(PagesController).to receive(:current_user).and_return(member)
          end

          it "displays results" do
            visit('/suche?query=search')
            expect(page).to have_content('This is a headline everybody should be able to search for.')
          end
        end
      end

      context "in multi_language mode" do
        let(:english_language)      { create(:alchemy_language, :english) }
        let(:english_language_root) { create(:alchemy_page, :language_root, language: english_language, name: 'Home') }
        let(:english_page)          { create(:alchemy_page, :public, parent_id: english_language_root.id, language: english_language) }
        let!(:english_element)      { create(:alchemy_element, page_id: english_page.id, name: 'article', create_contents_after_create: true) }

        before do
          element
          allow_any_instance_of(PagesController).to receive(:multi_language?).and_return(true)
        end

        it "does not display search results from other languages" do
          english_element.content_by_name('headline').essence.update!(body: 'Joes Hardware')
          visit('/de/suche?query=Hardware')
          expect(page).to have_css('h2.no_search_results')
          expect(page).to_not have_css('.search_result_list')
        end
      end
    end
  end
end
