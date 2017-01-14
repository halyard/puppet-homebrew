# == Class: homebrew
#
# Configure Homebrew

class homebrew (
  String[1] $path = '/usr/local',
  String[1] $owner = $facts['id'],
  String[1] $group = $facts['gid'],
  String[1] $repo = 'https://github.com/homebrew/brew',
  Hash[String[1], Hash] $taps = {},
  Array[String[1]] $formulae = []
) {
  vcsrepo { $path:
    ensure   => present,
    provider => git,
    source   => $repo,
    owner    => $owner,
    group    => $group
  }


  create_resources(homebrew::tap, $taps)

  $formulae.each |String[1] $formula| {
    package { $formula:
      provider => brew
    }
  }

  Homebrew::Tap <| |> -> Package <| provider == brew |>
  Homebrew::Tap <| |> -> Package <| provider == cask |>
}
