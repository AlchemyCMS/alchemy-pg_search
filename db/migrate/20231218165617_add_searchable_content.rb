class AddSearchableContent < ActiveRecord::Migration[7.0]
  def change
    add_column :pg_search_documents, :searchable_content, :virtual,
      type: :tsvector,
      as: "to_tsvector('#{Alchemy::PgSearch.config.fetch(:dictionary, "simple")}', coalesce(content, ''))",
      stored: true,
      if_not_exists: true
  end
end
