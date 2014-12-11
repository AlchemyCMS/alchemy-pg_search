class AddSearchableToAlchemyEssenceTexts < ActiveRecord::Migration
  def change
    add_column :alchemy_essence_texts, :searchable, :boolean, default: true
  end
end
