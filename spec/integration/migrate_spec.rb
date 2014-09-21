require 'spec_helper'

describe 'Mongration.migrate' do

  context 'when the migration is successful' do
    before do
      foo_create_migration
    end

    let(:migrate) { Mongration.migrate }

    it 'runs a single migration' do
      migrate
      expect(Foo.count).to eq(1)
    end

    it 'includes success message' do
      expect(Mongration.out).to receive(:puts).with('001 AddFoo: migrating')
      expect(Mongration.out).to receive(:puts).with('001 AddFoo: migrated')
      migrate
    end
  end

  context 'when there is an error in the first migration' do
    before do
      create_migration(
        '1_migration_with_error',
        up: 'raise StandardError'
      )
      create_migration(
        '2_migration_without_error',
        up: 'Foo.instances << Foo.new'
      )
    end

    let(:migrate) { Mongration.migrate }

    it 'does not run later migrations' do
      migrate
      expect(Foo.instances).to be_empty
    end

    it 'includes failed message' do
      expect(Mongration.out).to receive(:puts).with('1 MigrationWithError: migrating')
      expect(Mongration.out).to receive(:puts).with(/StandardError: An error has occured, this and all later migrations cancelled/)
      migrate
    end
  end

  it 'skips the first migration and runs a second migration' do
    foo_create_migration
    Mongration.migrate

    bar_create_migration
    Mongration.migrate

    expect(Foo.count).to eq(1)
    expect(Bar.count).to eq(1)
  end

  it 'does not migrate when there are no migrations' do
    foo_create_migration
    Mongration.migrate
    Mongration.migrate
    expect(Foo.count).to eq(1)
  end

  it 'migrates files in order' do
    foo_update_migration
    foo_create_migration
    Mongration.migrate

    foo = Foo.instances.first
    expect(foo.name).to eq('Test')
  end
end
