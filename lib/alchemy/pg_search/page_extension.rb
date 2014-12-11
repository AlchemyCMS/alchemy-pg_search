Alchemy::Page.class_eval do
  include PgSearch

  # TODO: include this in every essence
  # include Alchemy::PgSearch::Searchable

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

  def element_search_results(query)
    elements.search(query)
  end
end
