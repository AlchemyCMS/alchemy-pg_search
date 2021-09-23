module Alchemy::PgSearch::ContentExtension
  module ClassMethods
    def build(element, essence_hash)
      definition = content_definition(element, essence_hash)
      super.tap do |content|
        content.searchable = definition.key?(:searchable) ? definition[:searchable] : true
      end
    end

    Alchemy::Content.singleton_class.prepend self
  end

  module InstanceMethods
    def searchable_ingredient
      case essence_type
      when "Alchemy::EssencePicture"
        essence.caption
      when "Alchemy::EssenceRichtext"
        essence.stripped_body
      when "Alchemy::EssenceText"
        essence.body
      else
        ingredient
      end
    end

    Alchemy::Content.prepend self
  end
end
