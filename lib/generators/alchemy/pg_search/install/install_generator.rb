require "rails/generators"
require "rails/generators/active_record/migration"

module Alchemy
  module PgSearch
    class InstallGenerator < ::Rails::Generators::Base
      include ActiveRecord::Generators::Migration

      desc "Install Alchemy PgSearch - Gem into Rails App."

      source_root(File.expand_path("../../../..", __dir__))

      def install_migrations
        # Install pg_search multisearch - migration - the pg_search is not testing if the migration already exists
        generate("pg_search:migration:multisearch", abort_on_failure: true) unless self.class.migration_exists?("db/migrate", 'create_pg_search_documents')

        # Copy the migrations of the gem
        rake("alchemy_pg_search:install:migrations", abort_on_failure: true)
        
        # run migrations
        rake("db:migrate", abort_on_failure: true)
      end
    end
  end
end
