module Alchemy::Search::ElementExtension
  def self.prepended(base)
    base.attr_writer :searchable
  end

  def searchable
    definition.searchable
  end

  def searchable?
    searchable && public? && page.searchable? && page_version.public? && parent_elements_searchable?
  end

  def searchable_content
    ingredients.select(&:searchable?).map(&:searchable_content).join(" ").squish
  end

  def parent_elements_searchable?
    parent_element.nil? || (parent_element.searchable && parent_element.public? && parent_element.parent_elements_searchable?)
  end
end

Alchemy::Element.prepend(Alchemy::Search::ElementExtension)
