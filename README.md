puppet-homebrew
===========

[![MIT Licensed](http://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://tldrlegal.com/license/mit-license)
[![Build Status](https://img.shields.io/circleci/project/halyard/puppet-homebrew.svg)](https://circleci.com/gh/halyard/puppet-homebrew)

Module to install and manage homebrew for boxen

## Changes from upstream

* Removed a lot of meta-stuff I wasn't using, like the cardboard scripts
* Set up CircleCI build tests
* Set mode for brew boxen scripts
* Clean up update/install logic for latest version

## Usage

```puppet
include homebrew

# Declaring a custom package formula, and installing package

class clojure {
  homebrew::tap { 'homebrew/versions': }

  homebrew::formula {
    'clojure': ; # source defaults to puppet:///modules/clojure/brews/clojure.rb
    'leinengen':
      source => 'puppet:///modules/clojure/brews/leinengen.rb' ;
  }

  package {
    'boxen/brews/clojure':
      ensure => 'aversion' ;
    'boxen/brews/leinengen':
      ensure => 'anotherversion' ;
  }
}

# Installing homebrew formulas, and passing in arbitrary flags, like:
# brew install php54 --with-fpm --without-apache

package { 'php54':
  ensure => present,
  install_options => [
    '--with-fpm',
    '--without-apache'
  ],
  require => Package['zlib']
}
```

## Required Puppet Modules

* [boxen](https://github.com/halyard/puppet-boxen)
