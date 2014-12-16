require 'spec_helper'
require_relative '../shared/persisted_searchable.rb'

module Alchemy
  describe EssencePicture do

    it_behaves_like 'persisted searchable' do
      let(:essence) { EssencePicture.create! }
      let(:searchable_column) { 'caption' }
    end
  end
end
