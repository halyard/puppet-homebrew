# == Class: homebrew
#
# Configure Homebrew

class homebrew (
  $path = '/usr/local',
  $user = $facts['id'],
  $repo = 'git://github.com/homebrew/brew'
) {
  vcsrepo { $path:
    ensure   => present,
    provider => git,
    source   => $repo,
  }
}
