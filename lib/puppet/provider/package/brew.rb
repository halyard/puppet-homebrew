require 'puppet/provider/package'

Puppet::Type.type(:package).provide :brew, :parent => Puppet::Provider::Package do
  desc "Homebrew support for Mac packages"

  has_feature :installable, :upgradable, :uninstallable, :versionable, :install_options, :uninstall_options

  commands :brewcmd => "#{Puppet[:'homebrew::path']}/bin/brew"
end
