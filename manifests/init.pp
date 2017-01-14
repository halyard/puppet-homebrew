# == Class: homebrew
#
# Configure Homebrew

class homebrew (
  $path = '/usr/local',
  $owner = $facts['id'],
  $group = $facts['gid'],
  $repo = 'https://github.com/homebrew/brew',
  $taps = [],
  $formulae = []
) {
  vcsrepo { $path:
    ensure   => present,
    provider => git,
    source   => $repo,
    owner    => $owner,
    group    => $group
  }

  $taps.each |String[1] $tap| {
    package { $tap:
      provider => tap
    }
  }

  $formulae.each |String[1] $formula| {
    package { $formula:
      provider => brew
    }
  }

  Package <| provider == tap |> -> Package <| provider == brew |>
  Package <| provider == tap |> -> Package <| provider == cask |>
}
