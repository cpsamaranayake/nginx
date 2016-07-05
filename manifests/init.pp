class nginx {
  package { 'nginx':
	ensure => 'installed',
	}

  file { '/var/www':
	ensure => 'directory',
	owner => 'root',
	group => 'root',
	mode => '0775',
	}

  file { '/var/www/index.html':
	ensure => 'file',
	owner => 'root',
	group => 'root',
	mode => '0644',
	source => 'puppet:///modules/nginx/index.html',
	}

  service { 'nginx':
	ensure => 'running',
	enable => 'true',
	}

  file { '/etc/nginx/nginx.conf':
	ensure => 'file',
	owner => 'root',
	group => 'root',
	mode => '0644',
	source => 'puppet:///modules/nginx/nginx.conf',
	notify => Service['nginx'],
	require => Package['nginx'],
	}

  file { '/etc/nginx/conf.d/default.conf':
	ensure => 'file',
	owner => 'root',
	group => 'root',
	mode => '0644',
	source => 'puppet:///modules/nginx/default.conf',
	notify => Service['nginx'],
	require => Package['nginx'],
	}
}
