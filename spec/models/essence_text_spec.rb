require 'spec_helper'
require_relative '../shared/persisted_searchable.rb'

module Alchemy
  describe EssenceText do

    it_behaves_like 'persisted searchable' do
      let(:essence) { EssenceText.create! }
    end
  end
end
