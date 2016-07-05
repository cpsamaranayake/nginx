class nginx {
   case $::osfamily {
	'redhat','debian' : {
		$package = 'nginx'
		$owner = 'root'
		$group = 'root'
		$docroot = '/var/www'
		$confdir = '/etc/nginx'
		$blockdir = '/etc/nginx/conf.d'
		$provider = 'rpm'
		}
	'windows' : {
		$package = 'nginx-service'
		$owner = 'Administrator'
		$group = 'Administrators'
		$docroot = 'C:/ProgramData/nginx/html'
		$confdir = 'C:/ProgramData/nginx/conf'
		$blockdir = 'C:/ProgramData/nginx/conf.d'
		$provider = 'chocalatey'
		}
	default : {
		fail("Module ${module_name} is not supported on ${::osfamily}")
		}
	}
    File {
	owner => $owner,
	group => $group,
	mode => '0664',
	}

    package { $package:
	ensure => 'present',
	provider => $provider,
	}

    file { $docroot:
	ensure => 'directory',
	}

    file { "${docroot}/index.html":
	ensure => 'file',
	source => 'puppet:///modules/nginx/index.html',
	}

    file { "${confdir}/nginx.conf":
	ensure => 'file',
	source => "puppet:///modules/nginx/${::osfamily}.conf",
	notify => Service['nginx'],
	}

    file { "${blockdir}/default.conf":
	ensure => 'file',
	source => "puppet:///modules/nginx/default-${::kernel}.conf",
	notify => Service['nginx'],
	}

    service { 'nginx':
	ensure => 'running',
	enable => 'true',
	}
}
