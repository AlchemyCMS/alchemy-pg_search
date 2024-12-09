# Enable Postgresql full text indexing.
#
module Alchemy::PgSearch::PageExtension
  def self.prepended(base)
    base.include PgSearch::Model
    base.after_save :remove_unpublished_page
    base.multisearchable(
      against: [
        :name,
        :searchable_content
      ],
      additional_attributes: ->(page) { { page_id: page.id, searchable_created_at: page.public_on } },
      if: :searchable?,
    )
  end

  private

  def remove_unpublished_page
    ::PgSearch::Document.delete_by(page_id: id) unless searchable?
  end
end

Alchemy::Page.prepend(Alchemy::PgSearch::PageExtension)
