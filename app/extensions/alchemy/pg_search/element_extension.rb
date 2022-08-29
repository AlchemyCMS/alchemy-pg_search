module Alchemy::PgSearch::ElementExtension
  def searchable?
    public? && page.searchable? && page_version.public?
  end
end

Alchemy::Element.prepend(Alchemy::PgSearch::ElementExtension)
