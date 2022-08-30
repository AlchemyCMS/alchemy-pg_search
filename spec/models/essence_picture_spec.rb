require "spec_helper"

describe Alchemy::EssencePicture do
  let(:element) do
    page_version = create(:alchemy_page_version, :published)
    create(:alchemy_element, :with_contents, name: "essence_test", public: true, page_version: page_version)
  end
  let(:essence_picture) do
    essence = element.content_by_name("essence_picture").essence
    essence.caption = "foo"
    essence
  end

  context "searchable?" do
    context "content and essence_picture are searchable" do
      it "should be searchable" do
        expect(essence_picture.searchable?).to be(true)
      end
    end

    context "essence_picture has no content" do
      it "should be not searchable" do
        essence_picture.caption = nil
        expect(essence_picture.searchable?).to be(false)
      end
    end

    context "element is not public" do
      it "should be not searchable" do
        element.public = false
        expect(essence_picture.searchable?).to be(false)
      end
    end

    context "essence_picture has no related content" do
      let(:essence_picture) { create(:alchemy_essence_picture) }

      it "should be not searchable" do
        expect(essence_picture.searchable?).to be(false)
      end
    end
  end
end
