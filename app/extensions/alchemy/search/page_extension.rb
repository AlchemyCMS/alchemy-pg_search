# Enable Postgresql full text indexing.
#
module Alchemy::Search::PageExtension
  def searchable?
    (definition.key?(:searchable) ? definition[:searchable] : true) &&
      searchable && public? && !layoutpage?
  end
end

Alchemy::Page.prepend(Alchemy::Search::PageExtension)
