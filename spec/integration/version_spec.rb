require 'spec_helper'

describe 'Mongration.version' do

  context 'when there are no migrations' do
    it 'version is 0' do
      expect(Mongration.version).to eq(0)
    end
  end

  context 'when there are migration' do
    it 'version is equal to the number of non-empty migrations run' do
      foo_create_migration
      Mongration.migrate # non-empty migration
      Mongration.migrate # empty migration

      expect(Mongration.version).to eq(1)
    end
  end
end
