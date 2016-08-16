require 'rails'

module Alchemy
  module PgSearch
    class ViewsGenerator < ::Rails::Generators::Base
      desc "This generator copies the search form and result views into your project."

      source_root File.expand_path("../../../../../app/views/alchemy", File.dirname(__FILE__))

      def copy_views
        directory 'search', Rails.root.join('app/views/alchemy/search')
      end
    end
  end
end
