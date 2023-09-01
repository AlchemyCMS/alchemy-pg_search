require "alchemy/pg_search/engine"
require "alchemy/pg_search/config"
require "alchemy/pg_search/search"

module Alchemy
  module PgSearch
    SEARCHABLE_INGREDIENTS = %w[Text Richtext Picture]

    extend Config

    ##
    # is ingredient searchable?
    # @param ingredient_type [string]
    # @return [boolean]
    def self.is_searchable?(ingredient_type)
      SEARCHABLE_INGREDIENTS.include?(ingredient_type.gsub(/Alchemy::Ingredients::/, ""))
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
