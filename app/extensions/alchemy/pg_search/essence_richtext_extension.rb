module Alchemy::PgSearch::EssenceRichtextExtension

  def self.prepended(base)
    base.include PgSearch::Model
    base.multisearchable(
      against: [
        :stripped_body
      ],
      additional_attributes: -> (essence_richtext) { { page_id: essence_richtext.page.id } },
      if: :searchable?
    )
  end

  def searchable?
    stripped_body.present? && !!content&.searchable?
  end
end

Alchemy::EssenceRichtext.prepend(Alchemy::PgSearch::EssenceRichtextExtension)

