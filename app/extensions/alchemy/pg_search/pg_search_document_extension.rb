module Alchemy::PgSearch::PgSearchDocumentExtension
  def self.prepended(base)
    base.belongs_to :page, class_name: "::Alchemy::Page", foreign_key: "page_id", optional: true
  end
end

PgSearch::Document.prepend(Alchemy::PgSearch::PgSearchDocumentExtension)
