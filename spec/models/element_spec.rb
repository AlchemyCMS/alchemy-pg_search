require "spec_helper"

RSpec.describe Alchemy::Element do
  let(:element) do
    create(:alchemy_element, :with_contents, name: "mixed")
  end

  describe "searchable_essence_texts" do
    subject { element.searchable_essence_texts }

    let(:searchable_text) do
      element.content_by_name(:title).essence
    end

    let(:not_searchable_text) do
      element.content_by_name(:password).essence
    end

    it "returns searchable EssenceTexts" do
      expect(subject).to eq([searchable_text])
    end
  end

  describe "searchable_essence_richtexts" do
    subject { element.searchable_essence_richtexts }

    let(:searchable_richtext) do
      element.content_by_name(:public).essence
    end

    let(:not_searchable_richtext) do
      element.content_by_name(:confidential).essence
    end

    it "returns searchable EssenceTexts" do
      expect(subject).to eq([searchable_richtext])
    end
  end

  describe "searchable_essence_pictures" do
    subject { element.searchable_essence_pictures }

    let(:searchable_picture) do
      element.content_by_name(:image).essence
    end

    let(:not_searchable_picture) do
      element.content_by_name(:secret_image).essence
    end

    it "returns searchable EssenceTexts" do
      expect(subject).to eq([searchable_picture])
    end
  end
end
