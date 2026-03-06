# Enable Postgresql full text indexing.
#
module Alchemy::Search::PageExtension
  def searchable?
    definition.searchable && searchable && public? && !layoutpage?
  end

  def searchable_content
    all_elements.includes(ingredients: {element: :page}).map(&:searchable_content).join(" ")
  end
end

Alchemy::Page.prepend(Alchemy::Search::PageExtension)
