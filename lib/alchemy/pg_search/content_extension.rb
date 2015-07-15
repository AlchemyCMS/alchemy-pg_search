Alchemy::Content.class_eval do

  # Prepares the attributes for creating the essence.
  #
  # 1. It sets a default text if given in +elements.yml+
  # 2. It sets searchable value for EssenceText, EssencePicture and EssenceRichtext essences
  #
  def prepared_attributes_for_essence
    attributes = {
      ingredient: default_text(definition['default'])
    }
    if Alchemy::PgSearch.is_searchable_essence?(definition['type'])
      attributes.merge!(searchable: definition.fetch('searchable', true))
    end
    attributes
  end

  def searchable_ingredient
    case essence_type
    when 'Alchemy::EssencePicture'
      then essence.caption
    when 'Alchemy::EssenceRichtext'
      then essence.stripped_body
    when 'Alchemy::EssenceText'
      then essence.body
    else
      ingredient
    end
  end
end
