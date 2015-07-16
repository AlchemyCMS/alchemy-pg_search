module Alchemy
  module PgSearch

    # Ensures that the current content definition value for +searchable+ gets persisted.
    #
    # It is enabled per default, but you can disable indexing in your +elements.yml+ file.
    #
    # === Example
    #
    #   name: secrets
    #   contents:
    #   - name: confidential
    #     type: EssenceRichtext
    #     searchable: false
    #
    module Searchable
      extend ActiveSupport::Concern

      included do
        before_update do
          write_attribute(:searchable, definition.fetch('searchable', true))
          true
        end
      end
    end
  end
end
