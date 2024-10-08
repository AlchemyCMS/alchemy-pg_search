module Alchemy
  module PgSearch
    class IndexPageJob < BaseJob
      def perform(page)
        PgSearch.index_page(page)
      end
    end
  end
end

