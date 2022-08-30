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

        # We need to have the search methods present in all Alchemy controllers
        Alchemy::BaseController.send(:include, Alchemy::PgSearch::ControllerMethods)

        # reindex the page after it was published
        Alchemy.publish_targets << Alchemy::PgSearch::IndexPageJob
      end
    end
  end
end
