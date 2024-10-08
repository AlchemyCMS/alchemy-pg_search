module Alchemy
  module PgSearch

    # Provides full text search methods in your controller
    #
    module ControllerMethods

      # Adds a +before_action+ to your controller
      #
      def self.included(controller)
        controller.send(:before_action, :perform_search, only: :show)
        controller.send(:helper_method, :search_result_page)
        controller.send(:helper, Alchemy::PgSearch::SearchHelper)
      end

      private

      # Performs a full text search with +PgSearch+.
      #
      # Gets invoked everytime 'query' is given in params.
      #
      # This method only sets the +@search_results+ instance variable.
      #
      # You have to redirect to the search result page within a search form.
      #
      # === Alchemy provides a handy helper for rendering the search form:
      #
      #  render_search_form
      #
      # === Note
      #
      # If in preview mode a fake search value "lorem" will be set.
      #
      # @see Alchemy::PagesHelper#render_search_form
      #
      def perform_search
        set_preview_query
        return if params[:query].blank?
        @search_results = search_results
        if paginate_per
          @search_results = @search_results.page(params[:page]).per(paginate_per)
        end
      end

      # Find Pages that have what is provided in "query" param with PgSearch
      #
      # @return [Array]
      #
      def search_results
        Alchemy.search_class.search params[:query], ability: current_ability
      end

      # A view helper that loads the search result page.
      #
      # @return [Alchemy::Page,nil]
      #
      def search_result_page
        @search_result_page ||= begin
            page = Page.published.find_by(
              page_layout: search_result_page_layout["name"],
              language_id: Language.current.id,
            )
            if page.nil?
              logger.warn "\n++++++\nNo published search result page found. Please create one or publish your search result page.\n++++++\n"
            end
            page
          end
      end

      def search_result_page_layout
        # search for page layout with the attribute `searchresults: true`
        page_layouts = PageLayout.all.select do |page_layout|
          page_layout.key?(:searchresults) && page_layout[:searchresults].to_s.casecmp(true.to_s).zero?
        end
        if page_layouts.nil?
          raise "No searchresults page layout found. Please add page layout with `searchresults: true` into your `page_layouts.yml` file."
        end
        page_layouts.first
      end

      def paginate_per
        Alchemy::PgSearch.config[:paginate_per]
      end

      private

      def set_preview_query
        if self.class == Alchemy::Admin::PagesController && params[:query].blank?
          element = search_result_page&.draft_version&.elements&.named(:searchresults)&.first
          
          params[:query] = element&.value_for("search_string") || "lorem"
        end
      end
    end
  end
end
