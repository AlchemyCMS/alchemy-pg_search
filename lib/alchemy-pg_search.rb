require "alchemy/pg_search/engine"
require "alchemy/pg_search/config"
require "alchemy/pg_search/search"

module Alchemy
  module PgSearch
    SEARCHABLE_INGREDIENTS = %w[Text Richtext Picture]

    extend Config

    ##
    # is essence or ingredient searchable?
    # @param essence_type [string]
    # @return [boolean]
    def self.is_searchable?(essence_type)
      SEARCHABLE_INGREDIENTS.include?(essence_type.gsub(/Alchemy::(Essence|Ingredients::)/, ""))
    end

    ##
    # generate an array of all supported essences classes
    # @return [array]
    def self.searchable_essence_classes
      SEARCHABLE_INGREDIENTS.map { |k| "Alchemy::Essence#{k.classify}".constantize }
    end

    ##
    # search for page results
    #
    # @param query [string]
    # @param ability [nil|CanCan::Ability]
    # @return [ActiveRecord::Relation]
    def self.search(query, ability: nil)
      Search.search(query, ability: ability)
    end

    ##
    # index all supported Alchemy models
    def self.rebuild
      Search.rebuild
    end
  end
end
