require 'spec_helper'

describe Mongration::DataStore::Mongoid::Store do

  it_behaves_like 'store interface' do
    let(:store) do
      Mongration::DataStore::Mongoid::Store.new(
        config_path: 'spec/config/mongoid.yml'
      )
    end
  end
end
