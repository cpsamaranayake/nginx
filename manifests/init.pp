class nginx {
  File {
	owner => 'root',
	group => 'root',
	mode => '0644',
	}

  package { 'nginx':
	ensure => 'installed',
	}

  file { '/var/www':
	ensure => 'directory',
	}

  file { '/var/www/index.html':
	ensure => 'file',
	source => 'puppet:///modules/nginx/index.html',
	}

  service { 'nginx':
	ensure => 'running',
	enable => 'true',
	}

  file { '/etc/nginx/nginx.conf':
	ensure => 'file',
	source => 'puppet:///modules/nginx/nginx.conf',
	notify => Service['nginx'],
	require => Package['nginx'],
	}

  file { '/etc/nginx/conf.d/default.conf':
	ensure => 'file',
	source => 'puppet:///modules/nginx/default.conf',
	notify => Service['nginx'],
	require => Package['nginx'],
	}
}
