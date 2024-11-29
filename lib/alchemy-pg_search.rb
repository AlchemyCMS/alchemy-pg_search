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
    # index all supported Alchemy pages
    def self.rebuild
      ActiveRecord::Base.transaction do
        ::PgSearch::Document.delete_all
        Alchemy::Page.all.each{ |page| index_page(page) }
      end
    end

    ##
    # remove the whole index for the page
    #
    # @param page [Alchemy::Page]
    def self.remove_page(page)
      ::PgSearch::Document.delete_by(page_id: page.id)
    end

    ##
    # index a single page and indexable ingredients
    #
    # @param page [Alchemy::Page]
    def self.index_page(page)
      page.update_pg_search_document

      document = page.pg_search_document
      return if document.nil?

      ingredient_content = page.all_elements.includes(ingredients: {element: :page}).map do |element|
        element.ingredients.select { |i| i.searchable? }.map(&:searchable_content).join(" ")
      end.join(" ")

      document.update_column(:content, "#{document.content} #{ingredient_content}".squish)
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
