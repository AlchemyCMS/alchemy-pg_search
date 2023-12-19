class AddSearchableToAlchemyEssenceRichtexts < ActiveRecord::Migration[6.1]
  def change
    add_column :alchemy_essence_richtexts, :searchable, :boolean, default: true, if_not_exists: true
  end
end
