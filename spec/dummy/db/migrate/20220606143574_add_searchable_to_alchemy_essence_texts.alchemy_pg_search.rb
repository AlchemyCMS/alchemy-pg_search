# This migration comes from alchemy_pg_search (originally 20141211105526)
class AddSearchableToAlchemyEssenceTexts < ActiveRecord::Migration[5.1]
  def change
    add_column :alchemy_essence_texts, :searchable, :boolean, default: true
  end
end
