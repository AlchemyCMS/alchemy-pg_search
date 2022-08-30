module Alchemy::PgSearch::EssenceTextExtension
  def self.prepended(base)
    base.include PgSearch::Model
    base.multisearchable(
      against: [
        :body
      ],
      additional_attributes: -> (essence_text) { { page_id: essence_text.page.id } },
      if: :searchable?
    )
  end

  def searchable?
    body.present? && !!content&.searchable?
  end
end

Alchemy::EssenceText.prepend(Alchemy::PgSearch::EssenceTextExtension)

