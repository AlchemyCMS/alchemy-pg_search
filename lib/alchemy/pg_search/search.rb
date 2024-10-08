module Alchemy
  module PgSearch
    module Search

      ##
      # index all supported Alchemy models
      def self.rebuild
        [Alchemy::Page, Alchemy::Ingredient].each do |model|
          ::PgSearch::Multisearch.rebuild(model, transactional: false)
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
        remove_page page

        page.update_pg_search_document
        page.all_elements.includes(:ingredients).find_each do |element|
          element.ingredients.select { |i| Alchemy::PgSearch.is_searchable?(i.type) }.each do |ingredient|
            ingredient.update_pg_search_document
          end
        end
      end

      ##
      # search for page results
      #
      # @param query [string]
      # @param ability [nil|CanCan::Ability]
      # @return [ActiveRecord::Relation]
      def self.search(query, ability: nil)
        query = ::PgSearch.multisearch(query)
                  .select("JSON_AGG(content) as content", :page_id)
                  .reorder("")
                  .group(:page_id)
                  .joins(:page)

        query = query.merge(Alchemy::Page.accessible_by(ability, :read)) if ability

        query
      end
    end
  end
end
