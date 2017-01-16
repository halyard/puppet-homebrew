# Define Tap type

define homebrew::tap(
  Enum['present', 'absent'] $ensure = 'present',
  Variant[Undef, String[1]] $repo = undef
) {
  $chunks = split($title, '/')
  $slug = join($chunks, '/homebrew-')

  if $repo {
    $repo_url = $repo
  } else {
    $repo_url = "https://github.com/${slug}"
  }

  $repo_path = "${homebrew::path}/Library/Taps/${slug}"

  vcsrepo { $repo_path:
    ensure   => $ensure,
    provider => git,
    source   => $repo_url,
    owner    => $homebrew::owner,
    group    => $homebrew::group,
    require  => Vcsrepo[$homebrew::path]
  }
}
