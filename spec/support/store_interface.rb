shared_examples_for 'store interface' do
  it 'adds a migration' do
    migration = store.build_migration(1, ['001_foo.rb'])
    migration.save

    migration = store.migrations.first
    expect(migration.version).to eq(1)
    expect(migration.file_names).to eq(['001_foo.rb'])
  end

  it 'destroys a migration' do
    migration = store.build_migration(1, ['001_foo.rb'])
    migration.save
    migration.destroy

    expect(store.migrations).to eq([])
  end
end
