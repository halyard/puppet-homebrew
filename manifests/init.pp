# == Class: homebrew
#
# Configure Homebrew

class homebrew (
  String[1] $path = '/usr/local',
  String[1] $owner = $facts['id'],
  String[1] $group = $facts['gid'],
  String[1] $repo = 'https://github.com/Homebrew/brew',
  Hash[String[1], Hash] $taps = {},
  Array[String[1]] $formulae = [],
  Array[String[1]] $casks = []
) {
  vcsrepo { $path:
    ensure   => present,
    provider => git,
    source   => $repo,
    owner    => $owner,
    group    => $group
  }

  sudoers::allowed_command{ 'cask_installer':
    command               => "/usr/sbin/installer",
    user                  => $facts['id'],
    require_password      => false,
    require_exist         => false,
    tags                  => ['SETENV'],
    comment               => 'Allows homebrew to install casks'
  }

  create_resources(homebrew::tap, $taps)

  $formulae.each |String[1] $formula| {
    package { $formula:
      provider => brew
    }
  }

  $casks.each |String[1] $cask| {
    package { $cask:
      provider => cask
    }
  }

  Homebrew::Tap <| |> -> Package <| provider == brew |>
  Homebrew::Tap <| |> -> Package <| provider == cask |>
}
