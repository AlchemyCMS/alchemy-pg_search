module Alchemy::PgSearch::IngredientExtension

  def self.multisearch_config
    {
      against: [
        :value,
      ],
      additional_attributes: ->(ingredient) { { page_id: ingredient.element.page.id } },
      if: :searchable?
    }
  end

  def self.prepended(base)
    base.include PgSearch::Model
    base.multisearchable(multisearch_config)
  end

  def searchable?
    Alchemy::PgSearch.is_searchable?(type) &&
      (definition.key?(:searchable) ? definition[:searchable] : true) &&
      value.present? && !!element&.searchable?
  end
end

# add the PgSearch model to all ingredients
Alchemy::Ingredient.prepend(Alchemy::PgSearch::IngredientExtension)

# only enable the search for Text, Richtext, and Picture
Alchemy::Ingredients::Picture.multisearchable(Alchemy::PgSearch::IngredientExtension.multisearch_config.merge({against: [:caption]}))
