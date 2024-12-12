module Alchemy
  module PgSearch
    class IndexPageJob < BaseJob
      def perform(page)
        page.update_pg_search_document
      end
    end
  end
end

