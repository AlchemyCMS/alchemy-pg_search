# frozen_string_literal: true

module Alchemy
  module Search
    module SearchPage
      def self.perform_search(params, ability: nil)
        search_results = Alchemy.search_class.search(params[:query], ability:)
        search_results = search_results&.page(params[:page])&.per(paginate_per) if paginate_per.present?
        search_results
      end

      def self.paginate_per
        Alchemy::PgSearch.config[:paginate_per]
      end

      def self.search_result_page
        @search_result_page ||= begin
          page_layouts = PageLayout.all.select do |page_layout|
            page_layout.key?(:searchresults) && page_layout[:searchresults].to_s.casecmp(true.to_s).zero?
          end

          if page_layouts.nil?
            raise "No searchresults page layout found. Please add page layout with `searchresults: true` into your `page_layouts.yml` file."
          end

          page = Page.published.find_by(
            page_layout: page_layouts.first["name"],
            language_id: Language.current.id,
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
