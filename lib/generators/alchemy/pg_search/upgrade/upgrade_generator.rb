require 'rails'

module Alchemy
  module PgSearch
    class UpgradeGenerator < ::Rails::Generators::Base
      desc "This generator upgrades your project from alchemy-ferret based projects."
      source_root File.expand_path('templates', File.dirname(__FILE__))

      def replace_element_config
        gsub_file Rails.root.join('config/alchemy/elements.yml'),
          'do_not_index: true', 'searchable: false'
      end

      def copy_migration_file
        timestamp = Time.now.strftime('%Y%m%d%H%M%S')
        copy_file "migration.rb.tt", Rails.root.join("db/migrate/#{timestamp}_upgrade_from_alchemy_ferret.alchemy_pg_search.rb")
      end
    end
  end
end
