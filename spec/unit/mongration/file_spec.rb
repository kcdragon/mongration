require 'spec_helper'

describe Mongration::File do

  describe 'comparable' do
    it 'sorts by number' do
      second = Mongration::File.new('002_a.rb')
      first  = Mongration::File.new('001_b.rb')

      expect([second, first].sort).to eq([first, second])
    end

    it 'sorts by timestamp' do
      second = Mongration::File.new('20140825115042_a.rb')
      first  = Mongration::File.new('20140825115026_b.rb')

      expect([second, first].sort).to eq([first, second])
    end
  end
end
