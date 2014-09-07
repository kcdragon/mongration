require 'spec_helper'

describe 'Mongration.status' do

  context 'when there are no migrations' do
    it 'returns an empty array' do
      expect(Mongration.status).to eq([])
    end
  end

  context 'when there is a pending migration' do
    before do
      Mongration.create_migration('AddFoo')
    end

    let(:file_status) { Mongration.status.first }

    it "file's status is down" do
      expect(file_status.status).to eq('down')
    end

    it "file's migration id 001" do
      expect(file_status.migration_id).to eq('001')
    end

    it "file's migration name is 'add foo'" do
      expect(file_status.migration_name).to eq('add foo')
    end
  end

  context 'when there is a migration that is run' do
    before do
      Mongration.create_migration('AddFoo')
      Mongration.migrate
    end

    let(:file_status) { Mongration.status.first }

    it "file's status is up" do
      expect(file_status.status).to eq('up')
    end

    it "file's migration id 001" do
      expect(file_status.migration_id).to eq('001')
    end

    it "file's migration name is 'add foo'" do
      expect(file_status.migration_name).to eq('add foo')
    end
  end

  it 'sorted in ascending order by id' do
    Mongration.create_migration('AddFoo')
    Mongration.create_migration('AddFoo2')
    Mongration.migrate
    Mongration.create_migration('AddBar')
    Mongration.create_migration('AddBar2')

    expect(Mongration.status.map(&:migration_id)).to eq(%w(001 002 003 004))
  end
end
