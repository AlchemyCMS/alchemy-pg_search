# frozen_string_literal: true

require "spec_helper"

RSpec.describe Alchemy::PgSearch::IndexPageJob, type: :job do
  include ActiveJob::TestHelper

  let(:page) { create(:alchemy_page, :public) }

  it "calls the index_page - method" do
    expect(Alchemy::PgSearch).to receive(:index_page).with(page)
    described_class.perform_now(page)
  end
end
