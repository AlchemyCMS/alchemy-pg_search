require "alchemy_cms"
require "pg_search"

module Alchemy
  module PgSearch
    class Engine < ::Rails::Engine
      engine_name "alchemy_pg_search"

      config.to_prepare do
        Dir.glob(Alchemy::PgSearch::Engine.root.join("app", "extensions", "**", "*_extension.rb")) do |c|
          require_dependency(c)
        end

        # In development environment, this runs on every code reload, so avoid multiple reindexing jobs
        unless Alchemy.publish_targets.map(&:name).include? 'Alchemy::PgSearch::IndexPageJob'
          # reindex the page after it was published
          Alchemy.publish_targets << Alchemy::PgSearch::IndexPageJob
        end
        # enable searchable flag in page form
        Alchemy.enable_searchable = true

        # configure multiselect to find also partial words
        # @link https://github.com/Casecommons/pg_search#searching-using-different-search-features
        ::PgSearch.multisearch_options = {
          using: {
            tsearch: {
              prefix: true,
              dictionary: Alchemy::PgSearch.config.fetch(:dictionary, "simple"),
              tsvector_column: 'searchable_content'
            }
          }
        }
      end
    end
  end
end
