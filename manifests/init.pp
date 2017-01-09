# == Class: homebrew
#
# Configure Homebrew

class homebrew (
  $path = '/usr/local',
  $owner = $facts['id'],
  $group = $facts['gid'],
  $repo = 'git://github.com/homebrew/brew'
) {
  vcsrepo { $path:
    ensure   => present,
    provider => git,
    source   => $repo,
    owner    => $owner,
    group    => $group
  }
}
