module Alchemy::PgSearch::IngredientExtension
  def self.prepended(base)
    base.include PgSearch::Model
    base.multisearchable(
      against: [
        :value,
      ],
      additional_attributes: ->(ingredient) { { page_id: ingredient.element.page.id } },
      if: :searchable?,
    )
  end

  def searchable?
    Alchemy::PgSearch.is_searchable?(type) &&
      (definition.key?(:searchable) ? definition[:searchable] : true) &&
      value.present? && !!element&.searchable?
  end
end

Alchemy::Ingredient.prepend(Alchemy::PgSearch::IngredientExtension)
