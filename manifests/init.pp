class apt_conf (
    $ensure        = params_lookup('ensure'),
    $use_backports = params_lookup('use_backports')
    ) inherits apt_conf::params {

    Class['apt'] -> Class['apt_conf']
    
    apt::conf { 'apt_norecommends':
        ensure      => $ensure,
        priority    => '99',
        content     => 'APT::Install-Recommends \'0\';'
    }
    apt::conf { 'apt_periodic-updates':
        ensure      => $ensure,
        priority    => '99',
        content     => 'APT::Periodic::Update-Package-Lists 1;'
    }

    if $use_backports {
        apt::source { 'debian_backports':
            ensure              => $ensure,
            location            => 'http://backports.debian.org/debian-backports/',
            release             => 'squeeze-backports',
            repos               => 'main contrib non-free',
            required_packages   => 'debian-keyring debian-archive-keyring',
            include_src         => false,
            notify              => Exec['apt_update'],
            stage               => 'setup'
        }
    }
}
