# Public: Variables for working with Homebrew
#
# Examples
#
#   require homebrew::config

class homebrew::config(
  $installdir = $::homebrew_root
){
  include boxen::config

  $cachedir   = "${boxen::config::cachedir}/homebrew"
  $libdir     = "${installdir}/lib"

  $cmddir     = "${installdir}/Library/Homebrew/cmd"
  $tapsdir    = "${installdir}/Library/Taps"

  $brewsdir   = "${tapsdir}/boxen/homebrew-brews"

  $min_revision = 'e90b6e9ded2fd2c73a4e0d93f5dbc5b075a61b7c'
}
