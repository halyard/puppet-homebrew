# Define Tap type

define homebrew::tap(
  Enum['present', 'absent'] $ensure = 'present',
  Variant[Undef, String[1]] $repo = undef
) {
  if $repo {
    $repo_url = $repo
  } else {
    $chunks = split($title, '/')
    $slug = join($chunks, '/homebrew-')
    $repo_url = "https://github.com/${slug}"
  }

  $repo_path = "${homebrew::path}/Library/Taps/${title}"

  vcsrepo { $repo_path:
    ensure   => $ensure,
    provider => git,
    source   => $repo_url,
    owner    => $homebrew::owner,
    group    => $homebrew::group,
    require  => Vcsrepo[$homebrew::path]
  }
}
