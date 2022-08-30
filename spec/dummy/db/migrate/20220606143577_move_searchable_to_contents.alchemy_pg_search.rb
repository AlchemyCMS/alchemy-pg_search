# This migration comes from alchemy_pg_search (originally 20210923081905)
class MoveSearchableToContents < ActiveRecord::Migration[5.0]
  def change
    add_column :alchemy_contents, :searchable, :boolean, default: true

    {
      Text: "texts",
      Richtext: "richtexts",
      Picture: "pictures",
    }.each do |klass, table|
      reversible do |dir|
        dir.up do
          Alchemy::Content.connection.execute <<~SQL
            UPDATE alchemy_contents
            SET searchable = alchemy_essence_#{table}.searchable
            FROM alchemy_essence_#{table}
            WHERE
              alchemy_contents.essence_type = 'Alchemy::Essence#{klass}'
            AND
              alchemy_contents.essence_id = alchemy_essence_#{table}.id
          SQL
        end

        dir.down do
          Alchemy::Content.connection.execute <<~SQL
            UPDATE alchemy_essence_#{table}
            SET searchable = alchemy_contents.searchable
            FROM alchemy_contents
            WHERE
              alchemy_contents.essence_type = 'Alchemy::Essence#{klass}'
            AND
              alchemy_contents.essence_id = alchemy_essence_#{table}.id
          SQL
        end
      end

      remove_column "alchemy_essence_#{table}", :searchable, default: true
    end

    change_column_null :alchemy_contents, :searchable, false, true
  end
end
