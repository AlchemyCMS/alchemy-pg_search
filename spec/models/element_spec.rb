require "spec_helper"

RSpec.describe Alchemy::Element do
  let(:element) do
    page_version = create(:alchemy_page_version, :published)
    create(:alchemy_element, page_version: page_version)
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
end
