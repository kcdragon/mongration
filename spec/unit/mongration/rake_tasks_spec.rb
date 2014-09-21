require 'spec_helper'

describe 'rake tasks' do

  def run_task(task, args = nil)
    Rake::Task.define_task(:environment)
    Rake::Task[task].reenable

    if args
      Rake::Task[task].invoke(args)
    else
      Rake::Task[task].invoke
    end
  end

  describe 'db:migrate' do
    context 'when no VERSION is set' do
      it 'recives migrate with no args' do
        expect(Mongration).to receive(:migrate).with(nil)
        run_task('db:migrate')
      end
    end

    context 'when a VERSION is set' do
      it 'passes the version to migrate' do
        allow(ENV).to receive(:[]).with('VERSION').and_return('001')
        expect(Mongration).to receive(:migrate).with('001')
        run_task('db:migrate')
      end
    end
  end

  describe 'db:rollback' do
    context 'when not passed a STEP' do
      it 'receives rollback' do
        expect(Mongration).to receive(:rollback)
        run_task('db:rollback')
      end
    end

    context 'when passed a STEP of 2' do
      it 'calls rollback with 2' do
        allow(ENV).to receive(:[]).with('STEP').and_return('2')
        expect(Mongration).to receive(:rollback).with(2)
        run_task('db:rollback')
      end
    end
  end

  describe 'db:version' do
    it 'prints version' do
      allow(Mongration).to receive(:version).and_return(1)
      expect(Mongration.out).to receive(:puts).with('Current version: 1')
      run_task('db:version')
    end
  end

  describe 'db:migrate:create' do
    it 'receives create_migration' do
      allow(Mongration.out).to receive(:puts)
      expect(Mongration).to receive(:create_migration).with('add_foo').and_return('')
      run_task('db:migrate:create', 'add_foo')
    end

    it 'prints file name' do
      allow(Mongration).to receive(:create_migration).and_return('001_add_foo.rb')
      expect(Mongration.out).to receive(:puts).with('Created spec/db/migrate/001_add_foo.rb')
      run_task('db:migrate:create', 'add_foo')
    end
  end

  describe 'db:migrate:status' do
    it 'receives status' do
      allow(Mongration.out).to receive(:puts)
      expect(Mongration).to receive(:status).and_return([])
      run_task('db:migrate:status')
    end

    it 'prints migration info' do
      output = []
      allow(Mongration.out).to receive(:puts) do |arg|
        output << arg
      end

      status = Mongration::Status::FileStatus.new(:down, '001', 'add foo')
      allow(Mongration).to receive(:status).and_return([status])

      run_task('db:migrate:status')

      expect(output[0]).to match(/Status.*Migration ID.*Migration Name/)
      expect(output[1]).to match(/-+/)
      expect(output[2]).to match(/down.*001.*add foo/)
    end
  end
end
