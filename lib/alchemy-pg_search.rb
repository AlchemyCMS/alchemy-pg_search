require "alchemy/pg_search/engine"
require "alchemy/pg_search/config"
require "alchemy/pg_search/page_search_scope"

module Alchemy
  module PgSearch
    SEARCHABLE_ESSENCES = %w(EssenceText EssenceRichtext EssencePicture)
    DEFAULT_CONFIG = {
      page_search_scope: PageSearchScope.new
    }

    extend Config
    self.config = DEFAULT_CONFIG

    def self.is_searchable_essence?(essence_type)
      SEARCHABLE_ESSENCES.include?(essence_type)
    end

    def self.searchable_essence_classes
      SEARCHABLE_ESSENCES.map { |k| "Alchemy::#{k.classify}".constantize }
    end
  end
end
