require "alchemy_cms"
require "pg_search"

module Alchemy
  module PgSearch
    class Engine < ::Rails::Engine
      engine_name "alchemy_pg_search"

      config.to_prepare do
        require_relative "./content_extension"
        require_relative "./controller_methods"
        require_relative "./element_extension"
        require_relative "./page_extension"

        # We need to have the search methods present in all Alchemy controllers
        Alchemy::BaseController.send(:include, Alchemy::PgSearch::ControllerMethods)
      end
    end
  end
end
