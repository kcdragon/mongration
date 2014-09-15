shared_examples_for 'store interface' do
  it 'adds a migration' do
    store.store_migration(1, ['001_foo.rb'])

    expect(store.latest_migration_version).to eq(1)
    expect(store.latest_migration_file_names).to eq(['001_foo.rb'])
  end

  it 'destroys a migration' do
    store.store_migration(1, ['001_foo.rb'])
    store.remove_migration(1)

    expect(store.latest_migration_version).to eq(0)
    expect(store.latest_migration_file_names).to eq([])
    expect(store.migrated_file_names).to eq([])
  end

  it '#mirgated_file_names' do
    expect(store.migrated_file_names).to eq([])
    store.store_migration(1, ['001_foo.rb'])
    store.store_migration(2, ['002_bar.rb', '003_car.rb'])
    expect(store.migrated_file_names).to eq(['001_foo.rb', '002_bar.rb', '003_car.rb'])
  end
end
