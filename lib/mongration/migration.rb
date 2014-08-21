module Mongration
  class Migration
    include Mongoid::Document

    field :version, type: Integer

    embeds_many :files, class_name: 'Mongration::Migration::File'

    def self.migrated_file_names
      all.flat_map { |migration| migration.files.map(&:file_name) }
    end

    def self.next_migration_for(file_names)
      if file_names.present?
        migration = next_migration
        file_names.each do |file_name|
          migration.files.build(file_name: file_name)
        end
        migration
      else
        Null.new
      end
    end

    def self.latest_migration
      Migration.all.desc(:version).first || Null.new
    end

    def self.next_migration
      new(version: latest_version + 1)
    end
    private_class_method :next_migration

    def self.latest_version
      latest_migration.version
    end
    private_class_method :latest_version

    def up!
      files.each(&:up)
      save!
    end

    def down!
      files.each(&:down)
      destroy
    end
  end
end
