# This migration comes from alchemy (originally 20230505132743)
class AddIndexesToAlchemyPictures < ActiveRecord::Migration[ActiveRecord::Migration.current_version]
  def change
    add_index :alchemy_pictures, :name, if_not_exists: true
    add_index :alchemy_pictures, :image_file_name, if_not_exists: true
  end
end
