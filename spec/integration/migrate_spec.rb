require 'spec_helper'

describe 'Mongration.migrate' do

  context 'when the migration is successful' do
    before do
      foo_create_migration
      migrate
    end

    let(:migrate) { Mongration.migrate }

    it 'runs a single migration' do
      expect(Foo.count).to eq(1)
    end

    it 'returns successful result' do
      expect(migrate.success?).to be(true)
    end

    it 'includes success message' do
      expect { |b| migrate.each_message(&b) }.
        to yield_successive_args(
          '001 AddFoo: migrating',
          '001 AddFoo: migrated'
        )
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
      migrate
    end

    let(:migrate) { Mongration.migrate }

    it 'returns failed result' do
      expect(migrate.failed?).to be(true)
    end

    it 'includes failed message' do
      expect { |b| migrate.each_message(&b) }.
        to yield_successive_args(
          '1 MigrationWithError: migrating',
          /StandardError: An error has occured, this and all later migrations cancelled/
        )
    end

    it 'does not run later migrations' do
      expect(Foo.instances).to be_empty
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
