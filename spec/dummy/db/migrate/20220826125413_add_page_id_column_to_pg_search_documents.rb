class AddPageIdColumnToPgSearchDocuments < ActiveRecord::Migration[6.0]
  def change
    add_reference :pg_search_documents, :page, index: true
  end
end
