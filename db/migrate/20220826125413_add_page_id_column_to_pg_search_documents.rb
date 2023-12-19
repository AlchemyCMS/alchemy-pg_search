class AddPageIdColumnToPgSearchDocuments < ActiveRecord::Migration[6.0]
  def change
    unless column_exists? :pg_search_documents, :page
      add_reference :pg_search_documents, :page, index: true
    end
  end
end
