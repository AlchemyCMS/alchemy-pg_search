require "spec_helper"

RSpec.describe Alchemy::Page do
  let(:page) { create(:alchemy_page, :public) }

  let(:searchable_element) do
    create(:alchemy_element, :with_contents, page_version: page.public_version, name: "article")
  end

  let(:secret_element) do
    create(:alchemy_element, :with_contents, page_version: page.public_version, name: "secrets")
  end

  describe "searchable_contents" do
    subject { page.searchable_contents }

    let(:searchable_element) do
      create(:alchemy_element, :with_contents, page_version: page.public_version, name: "mixed")
    end

    let(:searchable_contents) do
      searchable_element.contents.where(name: %w[title public image])
    end

    it "returns searchable contents" do
      expect(subject).to eq(searchable_contents)
    end
  end

  describe "searchable_essence_texts" do
    subject { page.searchable_essence_texts }

    let!(:searchable_text) do
      searchable_element.content_by_name(:headline).essence
    end

    let!(:not_searchable_text) do
      secret_element.content_by_name(:passwords).essence
    end

    it "returns searchable EssenceTexts" do
      expect(subject).to eq([searchable_text])
    end
  end

  describe "searchable_essence_richtexts" do
    subject { page.searchable_essence_richtexts }

    let!(:searchable_richtext) do
      searchable_element.content_by_name(:text).essence
    end

    let!(:not_searchable_richtext) do
      secret_element.content_by_name(:confidential).essence
    end

    it "returns searchable EssenceTexts" do
      expect(subject).to eq([searchable_richtext])
    end
  end

  describe "searchable_essence_pictures" do
    subject { page.searchable_essence_pictures }

    let!(:searchable_picture) do
      searchable_element.content_by_name(:image).essence
    end

    let!(:not_searchable_picture) do
      secret_element.content_by_name(:image).essence
    end

    it "returns searchable EssenceTexts" do
      expect(subject).to eq([searchable_picture])
    end
  end
end
