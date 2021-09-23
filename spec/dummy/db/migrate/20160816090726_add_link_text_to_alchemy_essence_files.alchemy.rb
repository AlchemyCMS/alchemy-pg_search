# This migration comes from alchemy (originally 20150729151825)
class AddLinkTextToAlchemyEssenceFiles < ActiveRecord::Migration[5.1]
  def change
    add_column :alchemy_essence_files, :link_text, :string
  end
end
