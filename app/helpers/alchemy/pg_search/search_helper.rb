module Alchemy
  module PgSearch
    module SearchHelper

      # Renders a search form
      #
      # It queries the controller and then redirects to the search result page.
      #
      # === Example search results page layout
      #
      # Only performs the search if ferret is enabled in your +config/alchemy/config.yml+ and
      # a page is present that is flagged with +searchresults+ true.
      #
      #   # config/alchemy/page_layouts.yml
      #   - name: search
      #     searchresults: true # Flag as search result page
      #
      # === Note
      #
      # The search result page will not be cached.
      #
      # @option options html5 [Boolean] (true) Should the search form be of type search or not?
      # @option options class [String] (fulltext_search) The default css class of the form
      # @option options id [String] (search) The default css id of the form
      #
      def render_search_form(options = {})
        default_options = {
          html5: false,
          class: "fulltext_search",
          id: "search",
        }
        search_result_page = Alchemy::Search::SearchPage.search_result_page
        render "alchemy/search/form", options: default_options.merge(options), search_result_page:
      end

      def highlighted_excerpt(text, phrase, radius = 50)
        highlight(excerpt(text, phrase, radius: radius).to_s, phrase)
      end
    end
  end
end
