module Alchemy
  module PgSearch
    module Config
      @@config = {
        dictionary: 'simple',
        paginate_per: 10
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
