class nginx (
  $docroot  = nginx::params::docroot,
  $confdir  = nginx::params::confdir,
  $blockdir = nginx::params::blockdir,
  $owner    = nginx::params::owner,
  $group    = nginx::params::group,
  $package  = nginx::params::package,
  $logdir   = nginx::params::logdir, 
) inherits nginx::params {

    File {
	owner => $owner,
	group => $group,
	mode => '0664',
	}

    package { $package:
	ensure => 'present',
	}

    nginx::vhost { 'default':
	docroot => $docroot,
	servername => $::fqdn,
	}

    file { "${docroot}/vhosts":
	ensure => 'directory',
	}

    file { "${confdir}/nginx.conf":
	ensure => 'file',
	content => template('nginx/nginx.conf.erb'),
	notify => Service['nginx'],
	}

    service { 'nginx':
	ensure => 'running',
	enable => 'true',
	}
}
