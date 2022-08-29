require "spec_helper"

RSpec.describe Alchemy::Element do
  let(:searchable_element) do
    page_version = create(:alchemy_page_version, :published)
    create(:alchemy_element, page_version: page_version)
  end

  describe "searchable?" do
    describe "public element and public page" do
      it 'should be searchable' do
        expect(searchable_element.searchable?).to be(true)
      end
    end

    describe "public element and not published page" do
      let(:element) do
        create(:alchemy_element)
      end

      it 'should not be searchable' do
        expect(element.searchable?).to be(false)
      end
    end

    describe "public element and not published page_version" do
      let(:searchable_element) do
        page_version = create(:alchemy_page_version)
        create(:alchemy_element, page_version: page_version)
      end

      it 'should not be searchable' do
        expect(searchable_element.searchable?).to be(false)
      end
    end

    describe "not public element" do
      it 'should not be searchable' do
        searchable_element.public = false
        expect(searchable_element.searchable?).to be(false)
      end
    end
  end
end
