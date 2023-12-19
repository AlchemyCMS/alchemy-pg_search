class AddSearchableToAlchemyEssencePictures < ActiveRecord::Migration[6.1]
  def change
    add_column :alchemy_essence_pictures, :searchable, :boolean, default: true, if_not_exists: true
  end
end
