# == Class: homebrew
#
# Configure Homebrew

class homebrew (
  $path = '/usr/local',
  $user = $facts['id']
) {
}
