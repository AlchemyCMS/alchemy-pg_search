require "alchemy/pg_search/engine"

module Alchemy
  module PgSearch
    SEARCHABLE_ESSENCES = %w(EssenceText EssenceRichtext EssencePicture)

    def self.is_searchable_essence?(essence_type)
      SEARCHABLE_ESSENCES.include?(essence_type)
    end

    def self.searchable_essence_classes
      SEARCHABLE_ESSENCES.map { |k| "Alchemy::#{k.classify}".constantize }
    end
  end
end
