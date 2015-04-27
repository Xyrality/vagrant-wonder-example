include apt
include redis

apt::ppa { 'ppa:webupd8team/java': }

file { '/var/cache/debconf/oracle-jdk8-installer.preseed':
    content => 'oracle-java8-installer shared/accepted-oracle-license-v1-1 select true
',
    ensure => present,
}

package { 'oracle-java8-installer':
	ensure       => present,
	responsefile => '/var/cache/debconf/oracle-jdk8-installer.preseed',
	require      => [File['/var/cache/debconf/oracle-jdk8-installer.preseed'], Apt::Ppa['ppa:webupd8team/java'], ]
}

class { 'memcached':
	max_memory => '10%'
}

class { 'postgresql::globals':
	encoding            => 'UTF-8',
	locale              => 'en_US.UTF-8',
	version             => '9.4',
	manage_package_repo => true,
}

class { 'postgresql::server':
	ip_mask_allow_all_users    => '0.0.0.0/0',
	listen_addresses           => '*',
}

postgresql::server::role { 'xyrality-dev':
  password_hash => postgresql_password('xyrality-dev', 'xyrality'),
}

postgresql::server::database { 'bk_stage_world':
	owner => 'xyrality-dev',
	require => Postgresql::Server::Role['xyrality-dev']
}

postgresql::server::database { 'bk_stage_login':
	owner => 'xyrality-dev',
	require => Postgresql::Server::Role['xyrality-dev']
}

class { 'wonder':
	username => 'wouser',
	groupname => 'wouser',
}

wonder::application { 'Movies': }

file { '/home/wouser/.ssh':
	ensure => directory,
	require => User['wouser'],
	owner => 'wouser',
}

file { '/home/wouser/.ssh/authorized_keys':
	ensure => present,
	require => User['wouser'],
	source => 'file:///vagrant/wouser-ssh-key.pub',
	owner => 'wouser',
}

class { 'apache':
  default_mods   => false,
  default_vhost  => false,
}

apache::vhost { 'default-vhost':
	ensure          => present,
	port            => 80,
	docroot         => $apache::docroot,
	scriptalias     => $scriptalias,
	serveradmin     => $apache::serveradmin,
	access_log_file => $apache::access_log_file,
	priority        => '15',
	ip              => $apache::ip,
	logroot_mode    => $apache::logroot_mode,
	manage_docroot  => true
}
