class AddSearchableToAlchemyEssencePictures < ActiveRecord::Migration
  def change
    add_column :alchemy_essence_pictures, :searchable, :boolean, default: true
  end
end
