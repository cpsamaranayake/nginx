class nginx::params {
     case $::osfamily {
        'redhat','debian' : {
                $package = 'nginx'
                $owner = 'root'
                $group = 'root'
                $docroot = '/var/www'
                $confdir = '/etc/nginx'
                $blockdir = '/etc/nginx/conf.d'
                $logdir = '/var/log/nginx'
                }

        'windows' : {
                $package = 'nginx-service'
                $owner = 'Administrator'
                $group = 'Administrators'
                $docroot = 'C:/ProgramData/nginx/html'
                $confdir = 'C:/ProgramData/nginx/conf'
                $blockdir = 'C:/ProgramData/nginx/conf.d'
                $logdir = 'C:/ProgramData/nginx/logs'
                }

        default : {
                fail("Module ${module_name} is not supported on ${::osfamily}")
                }
        }

# Select the user based on the OS family.

    $user = $::osfamily ? {
        'windows' => 'no-body',
        'redhat' => 'nginx',
        'debian' => 'www-data',
        }
}
