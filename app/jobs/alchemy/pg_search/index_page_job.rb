module Alchemy
  module PgSearch
    class IndexPageJob < BaseJob
      def perform(page)
        Search.index_page(page)
      end
    end
  end
end

