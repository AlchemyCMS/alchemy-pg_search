class AddSearchableToAlchemyEssenceTexts < ActiveRecord::Migration[6.1]
  def change
    add_column :alchemy_essence_texts, :searchable, :boolean, default: true, if_not_exists: true
  end
end
