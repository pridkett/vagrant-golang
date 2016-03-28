class protobuf ( $version = "3.0.0-beta-2" ) {
  if ! defined(Package["unzip"]) {
    package { "unzip":
      ensure => present,
      before => Exec["unarchive-protobuf-tools"]
    }
  }
 
  exec { "download-protobuf":
    command => "/usr/bin/wget --no-check-certificate -O /usr/local/src/protoc-$version-linux-x86_64.zip https://github.com/google/protobuf/releases/download/v$version/protoc-$version-linux-x86_64.zip",
    creates => "/usr/local/src/protoc-$version-linux-x86_64.zip"
  }

  exec { "remove-previous-protobuf-version":
    command => "/bin/rm -f /usr/local/bin/protoc",
    onlyif => "/usr/bin/test -f /usr/local/bin/protoc",
    before => Exec["unarchive-protobuf-tools"]
  }

  exec { "unarchive-protobuf-tools":
    command => "/usr/bin/unzip /usr/local/src/protoc-$version-linux-x86_64.zip protoc -d /usr/local/bin",
    require => Exec["download-protobuf"]
  }
}
