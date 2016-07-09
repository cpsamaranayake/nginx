define nginx::vhost (
   $port = '80',
   $servername = $title,
   $docroot = "${nginx::docroot}/vhosts/${title}",
) {

  File {
	owner => $nginx::owner,
	group => $nginx::group,
	mode => '0644',
	}

  file { "nginx-vhost-${title}" :
    ensure => 'file',
    path => "${nginx::blockdir}/${title}.conf",
    content => template('nginx/vhost.conf.erb'),
    notify => Service['nginx'],
	}

  file { $docroot :
    ensure => 'directory',
    before => File["nginx-vhost-${title}"],
	}
 
  file { "${docroot}/index.html" :
    ensure => 'file',
    content => template('nginx/index.html.erb'),
	}
}
