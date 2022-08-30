module Alchemy::PgSearch::ContentExtension
  module ClassMethods
    def new(attributes)
      super.tap do |content|
        content.searchable = content.definition.key?(:searchable) ? content.definition[:searchable] : true
      end
    end

    Alchemy::Content.singleton_class.prepend self
  end

  module InstanceMethods
    def searchable?
      searchable && element.searchable?
    end

    Alchemy::Content.prepend self
  end
end
