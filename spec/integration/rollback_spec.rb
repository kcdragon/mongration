require 'spec_helper'

describe 'Mongration.rollback' do

  context 'when the rollback is successful' do
    before do
      foo_create_migration
      Mongration.migrate
    end

    it 'rollsback a migration' do
      Mongration.rollback
      expect(Foo.count).to eq(0)
    end

    it 'outputs messaging when starting and finishing the rollback' do
      expect(Mongration.out).to receive(:puts).with('001 AddFoo: reverting')
      expect(Mongration.out).to receive(:puts).with('001 AddFoo: reverted')
      allow(Mongration.out).to receive(:puts)
      Mongration.rollback
    end
  end

  context 'when the rollback is not successful' do
    before do
      create_migration(
        '1_migration_with_error',
        down: 'raise StandardError'
      )
      Mongration.migrate
    end

    it 'outputs messaging when rollback raises an error' do
      expect(Mongration.out).to receive(:puts).with('1 MigrationWithError: reverting')
      expect(Mongration.out).to receive(:puts).with('#<StandardError: StandardError>: An error has occured, this and all later migrations cancelled')
      allow(Mongration.out).to receive(:puts)
      expect { Mongration.rollback }.to raise_error
    end
  end

  it 'can rollback twice' do
    foo_create_migration
    bar_create_migration
    Mongration.migrate

    Mongration.rollback
    expect(Foo.count).to eq(1)

    Mongration.rollback
    expect(Foo.count).to eq(0)
  end

  it 'does not rollback when there are no migrations' do
    Foo.instances << Foo.new
    Mongration.rollback
    expect(Foo.count).to eq(1)
  end

  it 'rolls back files in order' do
    bar_create_migration
    bar_update_migration
    Mongration.migrate

    Mongration.rollback
    Mongration.rollback

    expect(Bar.count).to eq(0)
  end

  it 'rolls back multiple times when passed a step' do
    foo_create_migration
    bar_create_migration
    Mongration.migrate

    Mongration.rollback(2)
    expect(Foo.count).to eq(0)
    expect(Bar.count).to eq(0)
  end
end
