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
}
