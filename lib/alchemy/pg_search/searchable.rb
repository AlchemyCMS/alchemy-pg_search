module Alchemy
  module PgSearch

    # Ensures that the current content description value for +searchable+ gets persisted.
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
        before_save do
          write_attribute(:searchable, description.fetch('searchable', true))
          return true
        end
      end
    end
  end
end
