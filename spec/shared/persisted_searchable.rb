shared_examples_for 'persisted searchable' do
  let(:searchable_column) { 'body' }

  describe '.after_update' do
    it "updates the value for `searchable`" do
      allow(essence).to receive(:definition).and_return({'searchable' => false})
      essence.update!(searchable_column => 'hello')
      expect(essence.searchable).to be(false)
    end

    context "with `searchable` not set" do
      it "updates the value to true" do
        allow(essence).to receive(:definition).and_return({})
        essence.update!(searchable_column => 'hello')
        expect(essence.searchable).to be(true)
      end
    end
  end
end
