# = Class: apt::preseed_package
#
# Install preseed files for specific packages
#
# == Parameters:
#
# [* ensure *]
#   Specify the state for the package
#
# [* module *]
#   Specify the name of the package path in puppet source url
#
# [* install_options *]
#   Specify extra install options for apt or dpkg
#
# [* source *]
# Specify the source path for the module
# Default: false
#
define apt::preseed_package ( $ensure, $module, $install_options, $source = false ) {

    $puppet_path = "puppet:///modules/${module}/${name}.preseed"
    $real_source = $source ? {
      false => $puppet_path,
      default => $source,
    }
    file { "/var/local/preseed/":
      ensure => directory,
      owner  => root,
      group  => root,
      mode   => '0650',
    }
    file { "/var/local/preseed/${name}.preseed":
      source => $real_source,
      mode => 600,
      backup => false,
    }
    package { $name:
      ensure => $ensure,
      responsefile => "/var/local/preseed/${name}.preseed",
      require => File["/var/local/preseed/${name}.preseed"],
      install_options => $install_options,
    }

}
