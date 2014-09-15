require 'spec_helper'

describe 'Mongration.rollback' do

  it 'rollsback a migration' do
    foo_create_migration
    Mongration.migrate

    Mongration.rollback
    expect(Foo.count).to eq(0)
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
end
