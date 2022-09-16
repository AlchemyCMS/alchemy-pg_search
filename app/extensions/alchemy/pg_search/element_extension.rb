module Alchemy::PgSearch::ElementExtension
  def searchable?
    (definition.key?(:searchable) ? definition[:searchable] : true) &&
      public? && page.searchable? && page_version.public?
  end
end

Alchemy::Element.prepend(Alchemy::PgSearch::ElementExtension)
