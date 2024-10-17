module Alchemy::Search::IngredientExtension
  def searchable_content
    send(Alchemy.searchable_ingredients[type.to_sym])&.squish
  end

  def searchable?
    Alchemy.searchable_ingredients.has_key?(type.to_sym) &&
      (definition.key?(:searchable) ? definition[:searchable] : true) &&
      !!element&.searchable?
  end
end

# add the PgSearch model to all ingredients
Alchemy::Ingredient.prepend(Alchemy::Search::IngredientExtension)
