require "spec_helper"

describe Alchemy::EssenceRichtext do
  let(:element) do
    page_version = create(:alchemy_page_version, :published)
    create(:alchemy_element, :with_contents, name: "essence_test", public: true, page_version: page_version)
  end
  let(:essence_richtext) do
    essence = element.content_by_name("essence_richtext").essence
    essence.stripped_body = "foo"
    essence
  end

  context "searchable?" do
    context "content and essence_richtext are searchable" do
      it "should be searchable" do
        expect(essence_richtext.searchable?).to be(true)
      end
    end

    context "essence_richtext has no content" do
      it "should be not searchable" do
        essence_richtext.stripped_body = nil
        expect(essence_richtext.searchable?).to be(false)
      end
    end

    context "element is not public" do
      it "should be not searchable" do
        element.public = false
        expect(essence_richtext.searchable?).to be(false)
      end
    end

    context "essence_richtext has no related content" do
      let(:essence_richtext) do
        Alchemy::EssenceRichtext.new(
          stripped_body: "foo"
        )
      end

      it "should be not searchable" do
        expect(essence_richtext.searchable?).to be(false)
      end
    end
  end
end
