# frozen_string_literal: true

module Alchemy
  module Search
    module SearchPage
      def self.perform_search(params, ability: nil)
        search_results = Alchemy.search_class.search(params[:query], ability:)
        search_results = search_results&.page(params[:page])&.per(paginate_per) if paginate_per.present?

        # order the documents by searchable_created_at and use the ranking order as second order argument
        if params[:sort] == "date"
          search_results.order_values.unshift("pg_search_documents.searchable_created_at DESC")
        end

        search_results
      end

      def self.paginate_per
        Alchemy::PgSearch.config[:paginate_per]
      end

      def self.search_result_page
        @search_result_page ||= begin
          page_definitions = ::Alchemy::PageDefinition.all.select do |page_definition|
            page_definition.searchresults
          end

          if page_definitions.nil?
            raise "No searchresults page layout found. Please add page layout with `searchresults: true` into your `page_layouts.yml` file."
          end

          page = Page.published.find_by(
            page_layout: page_definitions.first.name,
            language_id: ::Alchemy::Current.language.id,
          )
          if page.nil?
            logger.warn "\n++++++\nNo published search result page found. Please create one or publish your search result page.\n++++++\n"
          end
          page
        end
      end
    end
  end
end
