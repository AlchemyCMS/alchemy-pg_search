require "spec_helper"

describe Alchemy::EssenceText do
  let(:element) do
    page_version = create(:alchemy_page_version, :published)
    create(:alchemy_element, :with_contents, name: "essence_test", public: true, page_version: page_version)
  end
  let(:essence_text) do
    essence = element.content_by_name("essence_text").essence
    essence.body = "foo"
    essence
  end

  context "searchable?" do
    context "content and essence_text are searchable" do
      it "should be searchable" do
        expect(essence_text.searchable?).to be(true)
      end
    end

    context "essence_text has no content" do
      it "should be not searchable" do
        essence_text.body = nil
        expect(essence_text.searchable?).to be(false)
      end
    end

    context "element is not public" do
      it "should be not searchable" do
        element.public = false
        expect(essence_text.searchable?).to be(false)
      end
    end

    context "essence_text has no related content" do
      let(:essence_text) { create(:alchemy_essence_text) }

      it "should be not searchable" do
        expect(essence_text.searchable?).to be(false)
      end
    end
  end
end
