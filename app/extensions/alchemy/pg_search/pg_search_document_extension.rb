module Alchemy::PgSearch::PgSearchDocumentExtension
  def self.prepended(base)
    base.belongs_to :page, class_name: "::Alchemy::Page", foreign_key: "page_id"
  end

  ##
  # get a list of excerpts of the searched phrase
  # The JSON_AGG - method will transform the grouped content entries into json which have to be "unpacked".
  # @return [array<string>]
  def excerpts
    return [] if content.blank?
    begin
      parsed_content = JSON.parse content
      parsed_content.kind_of?(Array) ? parsed_content : []
    rescue JSON::ParserError
      []
    end
  end
end

PgSearch::Document.prepend(Alchemy::PgSearch::PgSearchDocumentExtension)
