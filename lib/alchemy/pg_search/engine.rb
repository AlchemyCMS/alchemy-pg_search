require 'alchemy_cms'
require 'pg_search'

module Alchemy
  module PgSearch
    class Engine < ::Rails::Engine
      engine_name 'alchemy_pg_search'

      config.to_prepare do
        require_relative "./content_extension"
        require_relative './controller_methods'
        require_relative "./element_extension"
        require_relative "./page_extension"
        require_relative './searchable'

        # We need to have the search methods present in all Alchemy controllers
        Alchemy::BaseController.send(:include, Alchemy::PgSearch::ControllerMethods)

        # Inject searchable attribute persistence into searchable essence classes
        Alchemy::PgSearch.searchable_essence_classes.each do |klass|
          klass.send(:include, Alchemy::PgSearch::Searchable)
        end
      end
    end
  end
end
