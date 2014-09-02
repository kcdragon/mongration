require 'spec_helper'

describe 'Mongration.migrate' do

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
