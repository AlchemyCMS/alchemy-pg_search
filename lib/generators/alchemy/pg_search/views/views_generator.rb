require 'rails'

module Alchemy
  module PgSearch
    class ViewsGenerator < ::Rails::Generators::Base
      desc "This generator copies the search form and result views into your project."

      def copy_views
        directory File.expand_path('../../../../../app/views/alchemy/search', File.dirname(__FILE__)),
          Rails.root.join('app/views/alchemy/search')
      end
    end
  end
end
