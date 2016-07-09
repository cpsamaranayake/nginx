class nginx (
  $root = undef, 
) {
   case $::osfamily {
	'redhat','debian' : {
		$package = 'nginx'
		$owner = 'root'
		$group = 'root'
#		$docroot = '/var/www'
		$confdir = '/etc/nginx'
		$blockdir = '/etc/nginx/conf.d'
		$logdir	= '/var/log/nginx'
# Use below default docroot if not specified.
		$default_docroot = '/var/www'
		}

	'windows' : {
		$package = 'nginx-service'
		$owner = 'Administrator'
		$group = 'Administrators'
#		$docroot = 'C:/ProgramData/nginx/html'
		$confdir = 'C:/ProgramData/nginx/conf'
		$blockdir = 'C:/ProgramData/nginx/conf.d'
		$logdir = 'C:/ProgramData/nginx/logs'
# Use below default docroot if not specified.
                $default_docroot = 'C:/ProgramData/nginx/html'
		}

	default : {
		fail("Module ${module_name} is not supported on ${::osfamily}")
		}
	}

# If $root isn't set, then fall back to platform defaults.
   $docroot = $root ? {
  	undef => $default_docroot,
	default => $root,
	}

# Select the user based on the OS family.

    $user = $::osfamily ? {
	'windows' => 'no-body',
	'redhat' => 'nginx',
	'debian' => 'www-data',
	}

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

#    file { "${docroot}/index.html":
#	ensure => 'file',
#	content => template('nginx/index.html.erb'),
#	}

    file { "${confdir}/nginx.conf":
	ensure => 'file',
	content => template('nginx/nginx.conf.erb'),
	notify => Service['nginx'],
	}

#    file { "${blockdir}/default.conf":
#	ensure => 'file',
#	content => template('nginx/vhost.conf.erb'),
#	notify => Service['nginx'],
#	}

    service { 'nginx':
	ensure => 'running',
	enable => 'true',
	}
}
