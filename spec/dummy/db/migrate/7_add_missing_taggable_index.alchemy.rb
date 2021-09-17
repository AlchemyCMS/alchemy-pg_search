# This migration comes from alchemy (originally 20140701160225)
class AddMissingTaggableIndex < ActiveRecord::Migration[5.1]
  def self.up
    add_index :taggings, [:taggable_id, :taggable_type, :context]
  end

  def self.down
    remove_index :taggings, [:taggable_id, :taggable_type, :context]
  end
end
