module Alchemy
  module PgSearch
    module Config
      @@config = {
        paginate_per: 10,
        search_options: { # https://github.com/Casecommons/pg_search#searching-using-different-search-features
          using: {
            tsearch: { prefix: true }
          }
        }
      }

      def config=(settings)
        @@config.merge!(settings)
      end

      def config
        @@config
      end
    end
  end
end
