class AddSearchableToAlchemyEssenceTexts < ActiveRecord::Migration[5.1]
  def change
    add_column :alchemy_essence_texts, :searchable, :boolean, default: true
  end
end
