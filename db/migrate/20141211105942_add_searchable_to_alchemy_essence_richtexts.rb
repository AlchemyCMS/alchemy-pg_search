class AddSearchableToAlchemyEssenceRichtexts < ActiveRecord::Migration
  def change
    add_column :alchemy_essence_richtexts, :searchable, :boolean, default: true
  end
end
