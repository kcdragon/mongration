require 'spec_helper'

describe Mongration::DataStore::Mongoid do

  let(:migration) { Mongration::DataStore::Mongoid::Migration.create! }

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
      expect(Mongration::DataStore::Mongoid::Migration.count).to eq(0)
    end
  end
end
