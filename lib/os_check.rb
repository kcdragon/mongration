require 'rbconfig'

module OsCheck
  def self.mac_osx?
    RbConfig::CONFIG['host_os'] =~ /darwin|mac os/
  end
end
