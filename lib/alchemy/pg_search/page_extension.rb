Alchemy::Page.class_eval do
  include PgSearch

  # Enable Postgresql full text indexing.
  #
  pg_search_scope :search, against: {
      meta_description: 'B',
      meta_keywords:    'B',
      title:            'B',
      name:             'A'
    },
    associated_against: {
      searchable_essence_texts:     :body,
      searchable_essence_richtexts: :stripped_body,
      searchable_essence_pictures:  :caption
    },
    using: {
      tsearch: {prefix: true}
    }

  has_many :searchable_essence_texts,
    -> { where(searchable: true, alchemy_elements: {public: true}) },
    class_name: 'Alchemy::EssenceText',
    source_type: 'Alchemy::EssenceText',
    through: :contents,
    source: :essence

  has_many :searchable_essence_richtexts,
    -> { where(searchable: true, alchemy_elements: {public: true}) },
    class_name: 'Alchemy::EssenceRichtext',
    source_type: 'Alchemy::EssenceRichtext',
    through: :contents,
    source: :essence

  has_many :searchable_essence_pictures,
    -> { where(searchable: true, alchemy_elements: {public: true}) },
    class_name: 'Alchemy::EssencePicture',
    source_type: 'Alchemy::EssencePicture',
    through: :contents,
    source: :essence

  def element_search_results(query)
    elements.search(query)
  end
end
