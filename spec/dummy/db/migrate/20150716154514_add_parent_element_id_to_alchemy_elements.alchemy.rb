# This migration comes from alchemy (originally 20150608204610)
class AddParentElementIdToAlchemyElements < ActiveRecord::Migration[5.1]
  def change
    add_column :alchemy_elements, :parent_element_id, :integer
    add_index :alchemy_elements, [:page_id, :parent_element_id]
  end
end
