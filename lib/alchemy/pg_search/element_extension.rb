Alchemy::Element.class_eval do
  include PgSearch

  pg_search_scope :search,
    associated_against: {
      searchable_essence_texts:     :body,
      searchable_essence_richtexts: :stripped_body,
      searchable_essence_pictures:  :caption
    },
    using: {
      tsearch: {prefix: true}
    }

  has_many :searchable_essence_texts,
    class_name: 'Alchemy::EssenceText',
    source_type: 'Alchemy::EssenceText',
    through: :contents,
    source: :essence,
    conditions: {searchable: true, alchemy_elements: {public: true}}

  has_many :searchable_essence_richtexts,
    class_name: 'Alchemy::EssenceRichtext',
    source_type: 'Alchemy::EssenceRichtext',
    through: :contents,
    source: :essence,
    conditions: {searchable: true, alchemy_elements: {public: true}}

  has_many :searchable_essence_pictures,
    class_name: 'Alchemy::EssencePicture',
    source_type: 'Alchemy::EssencePicture',
    through: :contents,
    source: :essence,
    conditions: {searchable: true, alchemy_elements: {public: true}}

  has_many :searchable_contents,
    class_name: 'Alchemy::Content',
    source: :contents,
    conditions: {essence_type: ['Alchemy::EssenceText', 'Alchemy::EssenceRichtext', 'Alchemy::EssencePicture']}

end
