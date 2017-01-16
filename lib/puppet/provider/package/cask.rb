require 'puppet/provider/package'
require 'etc'

Puppet::Type.type(:package).provide :cask, :parent => Puppet::Provider::Package do
  desc "Homebrew cask support for Mac packages"

  mk_resource_methods

  has_feature :installable, :uninstallable

  # TODO: support alternate brew paths
  commands :brewcmd => "/opt/brew/bin/brew"

  def self.package_list
    return @package_list if @package_list
    command = [command(:brewcmd), 'cask', 'list']
    results = execute(command)
    @package_list = [] if results =~ /^Warning: nothing to list/
    @package_list ||= results.split.map do |pkg_name|
      {
        :name     => pkg_name,
        :ensure   => :present,
        :provider => :cask
      }
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def uninstall
    execute([command(:brewcmd), 'cask', 'uninstall', resource[:name]])
  end

  def install
    execute([command(:brewcmd), 'cask', 'install', resource[:name]])
  end

  def query
    self.class.package_list.find { |x| x[:name] == resource[:name].downcase }
  end

  def self.instances
    package_list.map { |hash| new(hash) }
  end

  def execute(cmd)
    self.class.execute(cmd)
  end

  def self.execute(cmd)
    stat = File.stat(command(:brewcmd))
    home = Etc.getpwuid(stat.uid).dir
    Puppet.debug(cmd.to_s)
    super(
      cmd,
      :uid => stat.uid,
      :gid => stat.gid,
      :failonfail => true,
      :combine => true,
      :custom_environment => { 'HOME' => home }
    )
  end
end
