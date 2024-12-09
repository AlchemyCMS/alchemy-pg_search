# frozen_string_literal: true

require "spec_helper"

RSpec.describe Alchemy::PgSearch::IndexPageJob, type: :job do
  include ActiveJob::TestHelper

  let(:page) { create(:alchemy_page, :public) }

  it "calls the update_pg_search_document - method" do
    expect(page).to receive(:update_pg_search_document)
    described_class.perform_now(page)
  end
end
