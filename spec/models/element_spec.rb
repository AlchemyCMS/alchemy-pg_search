require "spec_helper"

RSpec.describe Alchemy::Element do
  let(:element) do
    page_version = create(:alchemy_page_version, :published)
    create(:alchemy_element, page_version: page_version)
  end

  describe "#searchable" do
    subject { element.searchable }

    before do
      expect(Alchemy::Element).to receive(:definition_by_name).at_least(:once) do
        {
          name: "foo",
          searchable: false,
        }
      end
    end

    let(:element) { Alchemy::Element.create!(name: "foo", page_version: create(:alchemy_page_version)) }

    it { is_expected.to be false }
  end

  describe "searchable?" do
    subject { element.searchable? }

    context "public element and public page" do
      it "should be searchable" do
        is_expected.to be(true)
      end

      context "but configured as not searchable" do
        before do
          expect(element).to receive(:definition).at_least(:once) do
            {
              searchable: false,
            }
          end
        end

        it { is_expected.to be(false) }
      end
    end

    context "public element and not published page" do
      let(:element) do
        create(:alchemy_element)
      end

      it "should not be searchable" do
        is_expected.to be(false)
      end
    end

    context "public element and not published page_version" do
      let(:element) do
        page_version = create(:alchemy_page_version)
        create(:alchemy_element, page_version: page_version)
      end

      it "should not be searchable" do
        is_expected.to be(false)
      end
    end

    context "not public element" do
      it "should not be searchable" do
        element.public = false
        is_expected.to be(false)
      end
    end
  end

  describe "searchable_content" do
    let(:element) do
      page_version = create(:alchemy_page_version, :published)
      create(:alchemy_element, :with_ingredients, name: "ingredient_test", public: true, page_version: page_version)
    end
    let!(:first_ingredient) { create(:alchemy_ingredient_headline, value: "foo bar", element: element) }

    subject { element.searchable_content }

    it "should contain ingredient content" do
      is_expected.to eq("foo bar")
    end

    context "ignore not searchable elements" do
      before do
        element.public = false
        element.save
      end

      it "should not find the unsearchable content" do
        is_expected.to_not include("foo")
      end
    end
  end
end
