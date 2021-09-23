Alchemy::Element.class_eval do
  include PgSearch::Model

  pg_search_scope :full_text_search,
    associated_against: {
      searchable_essence_texts: :body,
      searchable_essence_richtexts: :stripped_body,
      searchable_essence_pictures: :caption,
    },
    using: {
      tsearch: { prefix: true },
    }

  has_many :searchable_essence_texts,
    -> {
      includes(:element)
        .where(alchemy_contents: { searchable: true })
        .where(alchemy_elements: { public: true })
    },
    class_name: "Alchemy::EssenceText",
    source_type: "Alchemy::EssenceText",
    through: :contents,
    source: :essence

  has_many :searchable_essence_richtexts,
    -> {
      includes(:element)
        .where(alchemy_contents: { searchable: true })
        .where(alchemy_elements: { public: true })
    },
    class_name: "Alchemy::EssenceRichtext",
    source_type: "Alchemy::EssenceRichtext",
    through: :contents,
    source: :essence

  has_many :searchable_essence_pictures,
    -> {
      includes(:element)
        .where(alchemy_contents: { searchable: true })
        .where(alchemy_elements: { public: true })
    },
    class_name: "Alchemy::EssencePicture",
    source_type: "Alchemy::EssencePicture",
    through: :contents,
    source: :essence

  has_many :searchable_contents,
    -> {
      where(essence_type: Alchemy::PgSearch::SEARCHABLE_ESSENCES.map { |k| "Alchemy::#{k}" })
    },
    class_name: "Alchemy::Content",
    source: :contents
end
