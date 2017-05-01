require 'puppet/provider/package'
require 'puppet/util/execution'
require 'etc'

Puppet::Type.type(:package).provide :brew, :parent => Puppet::Provider::Package do
  desc "Homebrew support for Mac packages"

  mk_resource_methods

  has_feature :installable, :uninstallable

  # TODO: support alternate brew paths
  commands :brewcmd => "/opt/brew/bin/brew"

  def self.package_list
    command = [command(:brewcmd), 'list', '--full-name']
    @package_list ||= execute(command).split.map do |pkg_name|
      {
        :name     => pkg_name,
        :ensure   => :present,
        :provider => :brew
      }
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def uninstall
    execute([command(:brewcmd), 'uninstall', resource[:name]])
  end

  def install
    execute([command(:brewcmd), 'install', resource[:name]])
  end

  def update
    install(false)
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
      :custom_environment => {
        'HOME' => home,
        'HOMEBREW_DEVELOPER' => '1',
        'HOMEBREW_RUBY_PATH' => Puppet::Util::Execution.ruby_path
      }
    )
  end
end
