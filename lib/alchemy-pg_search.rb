require "alchemy/pg_search/engine"
require "alchemy/pg_search/config"

module Alchemy
  mattr_accessor :search_class
  @@search_class = PgSearch

  mattr_accessor :searchable_ingredients
  @@searchable_ingredients = {
    "Alchemy::Ingredients::Text": :value,
    "Alchemy::Ingredients::Headline": :value,
    "Alchemy::Ingredients::Richtext": :stripped_body,
    "Alchemy::Ingredients::Picture": :caption,
  }

  module PgSearch
    extend Config

    ##
    # Reindex all supported Alchemy pages
    def self.rebuild(clean_up: true, transactional: true)
      ::PgSearch::Multisearch.rebuild(
        Alchemy::Page,
        clean_up: clean_up,
        transactional: transactional
      )
    end

    ##
    # search for page results
    #
    # @param query [string]
    # @param ability [nil|CanCan::Ability]
    # @return [ActiveRecord::Relation]
    def self.search(query, ability: nil)
      query = ::PgSearch.multisearch(query).includes(:searchable)

      if ability
        inner_ability_select = Alchemy::Page.select(:id).merge(Alchemy::Page.accessible_by(ability, :read))
        query = query.where("page_id IS NULL OR page_id IN (#{inner_ability_select.to_sql})")
      end

      query
    end
  end
end
