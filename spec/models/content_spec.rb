require 'spec_helper'
require_relative '../shared/searchable_essence.rb'

module Alchemy
  describe Content do

    Alchemy::PgSearch.searchable_essence_classes.each do |klass|
      describe "create an #{klass.model_name.name.demodulize}" do
        it_behaves_like "an searchable essence" do
          let(:essence_class) { klass }
        end
      end
    end
  end
end
