class AddSearchableToAlchemyEssencePictures < ActiveRecord::Migration[5.1]
  def change
    add_column :alchemy_essence_pictures, :searchable, :boolean, default: true
  end
end
