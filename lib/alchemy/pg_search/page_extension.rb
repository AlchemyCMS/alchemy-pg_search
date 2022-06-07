# Enable Postgresql full text indexing.
#
module Alchemy::PgSearch::PageExtension
  def self.extended(base)
    base.include InstanceMethods
    base.include PgSearch::Model

    base.pg_search_scope(
      :full_text_search,
      against: {
        meta_description: "B",
        meta_keywords: "B",
        title: "B",
        name: "A",
      },
      associated_against: {
        searchable_essence_texts: :body,
        searchable_essence_richtexts: :stripped_body,
        searchable_essence_pictures: :caption,
      },
      using: {
        tsearch: { prefix: true },
      },
    )

    base.has_many(
      :searchable_contents,
      -> { where(searchable: true) },
      class_name: "Alchemy::Content",
      through: :all_elements,
    )

    Alchemy::PgSearch::SEARCHABLE_ESSENCES.each do |klass|
      base.has_many(
        :"searchable_#{klass.underscore.pluralize}",
        class_name: "Alchemy::#{klass}",
        source_type: "Alchemy::#{klass}",
        through: :searchable_contents,
        source: :essence,
      )
    end
  end

  module InstanceMethods
    def element_search_results(query)
      all_elements.full_text_search(query)
    end
  end

  Alchemy::Page.extend self
end
