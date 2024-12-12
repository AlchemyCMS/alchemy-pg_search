module Alchemy::Search::ElementExtension
  def self.prepended(base)
    base.attr_writer :searchable
  end

  def searchable
    definition.key?(:searchable) ? definition[:searchable] : true
  end

  def searchable?
    searchable && public? && page.searchable? && page_version.public?
  end

  def searchable_content
    ingredients.select(&:searchable?).map(&:searchable_content).join(" ").squish
  end
end

Alchemy::Element.prepend(Alchemy::Search::ElementExtension)
