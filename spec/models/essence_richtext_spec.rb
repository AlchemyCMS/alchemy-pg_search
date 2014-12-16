require 'spec_helper'
require_relative '../shared/persisted_searchable.rb'

module Alchemy
  describe EssenceRichtext do

    it_behaves_like 'persisted searchable' do
      let(:essence) { EssenceRichtext.create! }
    end
  end
end
