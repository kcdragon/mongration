require 'spec_helper'

describe Mongration::Migration do

  let(:migration) { Mongration::Migration.create! }

  describe 'collection name' do
    it 'is mongration_migrations'do
      expect(Mongration::Migration.collection.name).to eq('mongration_migrations')
    end
  end

  describe '#create' do
    it 'sets created at timestamp' do
      expect(migration.created_at).to be_present
    end
  end

  describe '#destroy' do
    before { migration.destroy }

    it 'sets deleted at field' do
      migration.reload
      expect(migration.deleted_at).to be_present
    end

    it 'document is not returned in query' do
      expect(Mongration::Migration.count).to eq(0)
    end
  end
end
