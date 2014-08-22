require 'spec_helper'

describe Mongration::DataStore::InMemory::Store do

  it_behaves_like 'store interface' do
    let(:store) do
      Mongration::DataStore::InMemory::Store.new
    end
  end
end
