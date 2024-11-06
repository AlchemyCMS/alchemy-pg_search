class AddDocumentCreatedAtToPgSearchDocuments < ActiveRecord::Migration[7.1]
  def change
    add_column :pg_search_documents, :searchable_created_at, :datetime, if_not_exists: true
    add_index :pg_search_documents, :searchable_created_at, if_not_exists: true
  end
end
