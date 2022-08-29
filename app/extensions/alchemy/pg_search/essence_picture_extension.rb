module Alchemy::PgSearch::EssencePictureExtension

  def self.prepended(base)
    base.include PgSearch::Model
    base.multisearchable(
      against: [
        :caption
      ],
      additional_attributes: -> (essence_picture) { { page_id: essence_picture.page.id } },
      if: :searchable?
    )
  end

  def searchable?
    caption.present? && !!content&.searchable?
  end
end

Alchemy::EssencePicture.prepend(Alchemy::PgSearch::EssencePictureExtension)
