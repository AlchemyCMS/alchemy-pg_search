module Alchemy
  module PgSearch
    class PageSearchScope
      def pages
        Alchemy::Page.published.contentpages.with_language(Alchemy::Language.current.id)
      end
    end
  end
end
