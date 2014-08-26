require 'spec_helper'

describe Mongration do

  it 'runs a single migration' do
    foo_create_migration

    Mongration.migrate

    expect(Foo.count).to eq(1)
  end

  it 'skips the first migration and runs a second migration' do
    foo_create_migration
    Mongration.migrate

    bar_create_migration
    Mongration.migrate

    expect(Foo.count).to eq(1)
    expect(Bar.count).to eq(1)
  end

  it 'rollsback a migration' do
    foo_create_migration
    Mongration.migrate

    Mongration.rollback
    expect(Foo.count).to eq(0)
  end

  it 'can rollback twice' do
    foo_create_migration
    Mongration.migrate

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

  it 'rollbacks files in order' do
    bar_create_migration
    bar_update_migration
    Mongration.migrate
    Mongration.rollback

    expect(Bar.count).to eq(0)
  end
end
